//
//  Contatto.h
//  CoreDataPart2
//
//  Created by Developer on 18/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Contatto :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * nick;
@property (nonatomic, retain) NSString * cognome;
@property (nonatomic, retain) NSString * nome;

@end



