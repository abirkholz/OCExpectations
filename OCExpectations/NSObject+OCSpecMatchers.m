// OCExpectations NSObject+OCSpecMatchers.m
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

#import "NSObject+OCSpecMatchers.h"

#import "OCSpecTrueMatcher.h"
#import "OCSpecFalseMatcher.h"
#import "OCSpecNilMatcher.h"
#import "OCSpecEqualMatcher.h"
#import "OCSpecBeAKindOfMatcher.h"

@implementation NSObject(OCSpecMatchers)

+ (id<OCSpecMatcher>)beTrue
{
	return [[OCSpecTrueMatcher alloc] initWithExpected:nil];
}

+ (id<OCSpecMatcher>)beFalse
{
	return [[OCSpecFalseMatcher alloc] initWithExpected:nil];
}

+ (id<OCSpecMatcher>)beNil
{
	return [[OCSpecNilMatcher alloc] initWithExpected:nil];
}

- (id<OCSpecMatcher>)be
{
	return [self equal];
}

- (id<OCSpecMatcher>)beAKindOf
{
	return [[OCSpecBeAKindOfMatcher alloc] initWithExpected:self];
}

- (id<OCSpecMatcher>)equal
{
	return [[OCSpecEqualMatcher alloc] initWithExpected:self];
}

@end
