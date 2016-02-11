// OCExpectations OCExpectationsTests.m
//
// Copyright © 2012, The OCCukes Organisation. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import "OCExpectationsTests.h"

#import <OCExpectations/OCExpectations.h>

@implementation OCExpectationsTests

- (void)testShouldEqualNoThrow
{
	// 1 + 1 should = 2
	XCTAssertNoThrow([@(1 + 1) should:be(@2)]);
}

- (void)testShouldEqualThrows
{
	// 1 should NOT = 2
	XCTAssertThrows([@1 should:[@2 equal]]);
}

- (void)testShouldNotEqualNoThrow
{
	// 1 should NOT = 2
	XCTAssertNoThrow([@1 shouldNot:equal(@2)]);
}

- (void)testShouldBeTrue
{
	// Yes should yes be! Sounds Shakespearean. Or in other words, yes should be
	// yes. However, you cannot easily construct matchers as you can with RSpec
	// in Ruby. In Objective-C, the receiver must always come first and the
	// language does not support modular mix-ins.
	XCTAssertNoThrow([@YES should:[@YES be]]);
	XCTAssertThrows([@NO should:[@YES be]]);
}

- (void)testShouldBeFalse
{
	XCTAssertNoThrow([@NO should:[@NO be]]);
	XCTAssertThrows([@YES should:[@NO be]]);
}

- (void)testNot
{
	XCTAssertEqualObjects(OCSpecNot(@NO), @YES);
	XCTAssertEqualObjects(OCSpecNot(nil), @YES);

	// In Ruby, the following would answer false. That is, Ruby expression !0
	// answers false. However, in Objective-C, @0 equals @NO. They are one and
	// the same thing: both integer numbers with value of zero. Hence negating
	// zero equates to negating NO, answering YES.
	XCTAssertEqualObjects(OCSpecNot(@0), @YES);

	// Negating an object, any object, answers NO. Note that in Objective-C,
	// null is not nil, therefore a non-nil object answering NO.
	XCTAssertEqualObjects(OCSpecNot([NSNull null]), @NO);
}

- (void)testNotNot
{
	XCTAssertEqualObjects(OCSpecNot(OCSpecNot(@NO)), @NO);
	XCTAssertEqualObjects(OCSpecNot(OCSpecNot(@YES)), @YES);
	XCTAssertEqualObjects(OCSpecNot(OCSpecNot(nil)), @NO);
	XCTAssertEqualObjects(OCSpecNot(OCSpecNot([NSNull null])), @YES);
}

- (void)testBeAnInstanceOf
{
	NSObject *object = [[NSObject alloc] init];
	XCTAssertNoThrow([object should:be_an_instance_of(@"NSObject")]);
}

- (void)testBeAKindOf
{
	XCTAssertNoThrow([@123 should:[NSStringFromClass([NSNumber class]) beAKindOf]]);
}

- (void)testEqualHasObjectiveCSemantics
{
	XCTAssertNoThrow([@"5" should:[@"5" equal]]);
	XCTAssertNoThrow([@5 should:[@5 equal]]);
}

- (void)testExpectationNotMetException
{
	// When an expectation fails, it throws an NSException named
	// OCExpectationNotMetException. Make sure that that proves true. Give it
	// something that will always fail: one divided by three should never be
	// 0.333; not unless the floating-point unit has very, very low precision.
	XCTAssertThrowsSpecificNamed([@(1/3.0) should:be(@0.333)], NSException, OCExpectationNotMetException);
}

- (void)testYesShouldBeTrueNotFalse
{
	XCTAssertNoThrow([@YES should:be_true]);
	XCTAssertNoThrow([@YES shouldNot:be_false]);
}

- (void)testNoShouldBeFalseNotTrue
{
	XCTAssertNoThrow([@NO should:be_false]);
	XCTAssertNoThrow([@NO shouldNot:be_true]);
}

- (void)testNilShouldBeNull
{
	// In Objective-C, you cannot send messages to the nil literal. Sending [nil
	// should:aMatcher] using a literal nil fails at compile time: a "void *"
	// bad receiver type. However, you really can send to nil. You only have to
	// cast the nil to an id, that is, send [(id)nil should:aMatcher]. However,
	// Objective-C cannot match actual nils because nil receivers do not invoke
	// methods. When expecting nils therefore, convert the actual nils to nulls.
	id objectOrNil = nil;
	XCTAssertNoThrow([OCSpecNullForNil(objectOrNil) should:be_null]);
}

- (void)testEqlVersusEqual
{
	XCTAssertNoThrow([@"hello" should:equal(@"hello")]);

	// You might expect the following to not throw. However, it throws. Due to
	// clever compiler optimisations, the two strings share the same
	// identity. Strings in Apple's Foundation frameworks are immutable
	// atoms. Sharing an identity is normal and expected.
	//
	//	STAssertNoThrow([@"hello" shouldNot:eql(@"hello")], nil);
	//
	XCTAssertThrows([@"hello" shouldNot:eql(@"hello")]);

	// Work around compiler optimisations and warnings by constructing a string
	// from a C string. That will create two equal but non-identical
	// strings. They should compare equal but should not be identical.
	NSString *hello = [NSString stringWithCString:"hello" encoding:NSUTF8StringEncoding];
	XCTAssertNoThrow([hello shouldNot:eql(@"hello")]);
	XCTAssertNoThrow([hello should:equal(@"hello")]);
}

- (void)testBeWithin
{
	XCTAssertNoThrow([@2.5 should:[be_within(@0.5) of:@3.0]]);
	XCTAssertNoThrow([@3.5 should:[be_within(@0.5) of:@3.0]]);
	XCTAssertThrows([@1.5 should:[be_within(@0.5) of:@3.0]]);
	XCTAssertThrows([@4.5 should:[be_within(@0.5) of:@3.0]]);
	XCTAssertThrowsSpecificNamed([@3.0 should:be_within(@0.5)], NSException, NSInvalidArgumentException);
}

- (void)testIncludes
{
	// Preprocessor macros do not play nicely with Objective-C array and
	// dictionary literals. The compiler complains about "too many arguments
	// provided to function-like macro invocation." Non-collection literals work
	// without problems. Catch the exceptions without using the macros until the
	// LLVM project resolves this compiler issue. For example, use
	//
	//	[@[@1, @2, @3] should:[@[@1, @2] include]];
	//
	// instead of
	//
	//	[@[@1, @2, @3] should:include(@[@1, @2])];
	//
	@try
	{
		// arrays
		[@[@1, @2, @3] should:include(@2)];
		[@[@1, @2, @3] should:[@[@1, @2] include]];

		// hashes
		[@{@"alpha": @1, @"beta": @2, @"gamma": @3} should:include(@"beta")];
		[@{@"alpha": @1, @"beta": @2, @"gamma": @3} should:[@[@"beta", @"gamma"] include]];
		[@{@"alpha": @1, @"beta": @2, @"gamma": @3} should:[@{@"beta": @2, @"gamma": @3} include]];

		// The following expectation passes because 1, 1 is a subset of 1. The
		// includes matcher converts actuals and expected's to sets before
		// answering. Array 1, 1 becomes set 1; 1 is one and the same object.
		[@1 should:[@[@1, @1] include]];
	}
	@catch (NSException *exception)
	{
		//[self failWithException:exception];
	}
}

- (void)testCompare
{
	XCTAssertNoThrow([@123 should:[@123 compareSame]]);
	XCTAssertNoThrow([@123 should:compare_same(@123)]);

	XCTAssertNoThrow([@1 should:compare_ascending(@2)]);
	XCTAssertNoThrow([@2 should:compare_descending(@1)]);

	XCTAssertNoThrow([@1 shouldNot:compare_ascending(@1)]);
	XCTAssertNoThrow([@1 shouldNot:compare_descending(@1)]);

	XCTAssertNoThrow([@1 should:compare_less_than(@2)]);
	XCTAssertNoThrow([@2 should:compare_more_than(@1)]);

	XCTAssertNoThrow([[NSDate date] should:compare_less_than([NSDate dateWithTimeIntervalSinceNow:1.0])]);

	// Actual should compare "same or more than" expected becomes actual should
	// "not compare less than" expected.
	for (NSNumber *number in @[ @1, @2, @3, @4 ])
	{
		XCTAssertNoThrow([number shouldNot:compare_less_than(@1)]);
	}
}

- (void)testIndexedSubscripting
{
	@try
	{
		[@[@"a", @"b", @"c"][0] should:be(@"a")];
	}
	@catch (NSException *exception)
	{
		//[self failWithException:exception];
	}
}

- (void)testRecursiveEnumeration
{
	NSMutableArray *objects = [NSMutableArray array];
	for (NSDictionary *dictionary in [[OCRecursiveEnumeration alloc] initWithSuperObject:@{@0: @{@1: @{@2: @{}}}} usingSubSelector:@selector(allValues) inclusive:NO inclusiveBlock:NULL])
	{
		[objects addObjectsFromArray:[dictionary allKeys]];
	}
	XCTAssertEqualObjects((@[@1, @2]), objects);
}

- (void)testVersioning
{
	XCTAssertNotNil(OCExpectationsVersionString());
	XCTAssertTrue(strcmp(@encode(typeof(kOCExpectationsVersionString)), "^C") == 0);
	XCTAssertTrue(strcmp(@encode(typeof(kOCExpectationsVersionNumber)), "d") == 0);
}

@end
