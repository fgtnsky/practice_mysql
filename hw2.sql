# Name: Wenjun Zeng
# ID: 4922760

#A1.
#A1a.
CREATE TABLE Customer(custid INTEGER, PRIMARY KEY(custid))
CREATE TABLE Product(pid CHAR(11), PRIMARY KEY(pid))
CREATE TABLE Transaction(tid CHAR(11), PRIMARY KEY(tid))
CREATE TABLE Buy(custid INTEGER, pid CHAR(11), tid CHAR(11),
  PRIMARY KEY(tid), FOREIGN KEY(custid) REFERENCES Customer,
  FOREIGN KEY(pid) REFERENCES Product,FOREIGN KEY(tid) REFERENCES
  Transaction)


#A1B.
CREATE TABLE Customer(custid INTEGER, PRIMARY KEY(custid))
CREATE TABLE Product(pid CHAR(11), PRIMARY KEY(pid))
CREATE TABLE Buy(custid INTEGER, pid CHAR(11), tid CHAR(11),
  PRIMARY KEY(custid, pid), FOREIGN KEY(custid) REFERENCES Customer,
  FOREIGN KEY(pid) REFERENCES Product)

#A1C.
CREATE TABLE Customer(custid INTEGER, PRIMARY KEY(custid))
CREATE TABLE Product(pid CHAR(11), PRIMARY KEY(pid))
CREATE TABLE Buy(custid INTEGER, pid CHAR(11), tid CHAR(11),
  PRIMARY KEY(custid, pid), FOREIGN KEY(custid) REFERENCES Customer,
  FOREIGN KEY(pid) REFERENCES Product)

#A1D
# Since each customer has a unque product to buy, we could
# instead combine Buy and Cutomer.
CREATE TABLE Product(pid CHAR(11), PRIMARY KEY(pid))
CREATE TABLE Customer_Buy(custid INTEGER, pid CHAR(11), tid CHAR(11),
  PRIMARY KEY(custid),
  FOREIGN KEY(pid) REFERENCES Product  ON DELETE CASCADE)


# A2.
CREATE TABLE Publishers(name CHAR(11), PRIMARY KEY(name))
CREATE TABLE Published_Books(ISBN CHAR(11), book_name CHAR(11), name CHAR(11),
  PRIMARY KEY(ISBN), FOREIGN KEY(name) REFERENCES Publishers)
CREATE TABLE AUthors(name CHAR(11), PRIMARY KEY(name))
CREATE TABLE Categories(name CHAR(11), PRIMARY KEY(name))
CREATE TABLE Authored(ISBN CHAR(11), name CHAR(11), PRIMARY KEY(ISBN,NAME))
CREATE TABLE ParentOf(Parent_Category CHAR(11), Son_Category CHAR(11),
  PRIMARY KEY(Parent_Category, Son_Category),
  FOREIGN KEY(Parent_Category) REFERENCES Categories(name),
  FOREIGN KEY(Son_Category) REFERENCES Categories(name))


# A3.
CREATE TABLE Staff(netid CHAR(11), name CHAR(11), PRIMARY KEY(netid))
CREATE TABLE Creates_Homework(number INTEGER, topic CHAR(11), netid CHAR(11),
  PRIMARY KEY(number), FOREIGN KEY(netid) REFERENCES Staff)
CREATE TABLE Professor(netid CHAR(11), office CHAR(11), PRIMARY KEY(netid),
  FOREIGN KEY(netid) REFERENCES Staff ON DELETE CASCADE)
CREATE TABLE TA(netid CHAR(11),  PRIMARY KEY(netid),
  FOREIGN KEY(netid) REFERENCES Staff ON DELETE CASCADE)
CREATE TABLE Course(cid CHAR(11), title CHAR(11), PRIMARY KEY(cid))
CREATE TABLE teaches(cid CHAR(11), netid CHAR(11), PRIMARY KEY(netid, cid),
  FOREIGN KEY(netid) REFERENCES Professor,
  FOREIGN KEY(cid) REFERENCES Course)
CREATE TABLE Has_Section(time CHAR(11), room CHAR(11), cid CHAR(11),
  PRIMARY KEY(room, time), FOREIGN KEY(cid) REFERENCES Course)
CREATE TABLE covers(netid CHAR(11), time CHAR(11), room CHAR(11),
  PRIMARY KEY(netid, time, room),
  FOREIGN KEY(netid) REFERENCES TA,
  FOREIGN KEY(time, room) REFERENCES Section)


# C1
# a
SELECT suppId1, suppId2
FROM
  (SELECT count(*) as c, T1.suppId as suppId1, T2.suppId as suppId2,
    T1.prod_count as c1, T2.prod_count as c2
  FROM
    (SELECT SuppInfo.suppId, SuppInfo.prodId, count.prod_count
    FROM SuppInfo,
      (SELECT suppId, count(*) as prod_count
      FROM SuppInfo
      GROUP BY suppId) as count # generate the T2 of product for each supply
    WHERE SuppInfo.suppId = count.SuppId) as T1,
    # combine numberOfProduct with original table
    (SELECT SuppInfo.suppId, SuppInfo.prodId, count.prod_count
    FROM SuppInfo,
      (SELECT suppId, count(*) as prod_count
      FROM SuppInfo
      GROUP BY suppId) as count
    WHERE SuppInfo.suppId = count.SuppId) as T2,
    # the same table as T1
  WHERE T1.suppId < T2.suppId AND T1.prodId = T2.prodId
  GROUP BY T1.suppId, T2.suppId) as T
  # combine two tables together, and calculate the total # of shared products
WHERE c = c1 AND c1 = c2
  # if the # of shared products = # of products of T1 = # of products of T2

# b
SELECT custId
FROM
  (SELECT count(*) as count, purchaseId
    (SELECT DISTINCT purchaseId, purchaseMethod
    FROM Purchases) as T1
  GROUP BY purchaseId) as T2, Purchases
WHERE T2.purchaseId = Purchases.purchaseId AND count = 2


# C2
### first find DISTINCT cId, pId from table Buys, we do not care repeated Transaction
### group by pId of this new table and calculate how many customer bought before
### if this number is the same as the number of customer then select it
### then find all the cid that has bought products not in this list
### then use all cid - the cid above

SELECT cName
FROM Customer
WHERE cid NOT IN
  (SELECT DISTINCT cId FROM
    (SELECT cName, Customer.cId as cId, pId
    FROM Customer,
      (SELECT DISTINCT cId, pId
      FROM Buys) as T3
    WHERE Customer.cId = T3.cId) as T2
  WHERE pId not in
    (SELECT pId
    FROM
      (SELECT DISTINCT cId, pId
      FROM Buys) as T1
    GROUP BY pId
    WHERE count(*) = (select count(*) from Customer)))


# C3

SELECT name
FROM Actors
WHERE aId not in
  (SELECT A.aId
  FROM Actors A, Directors D, Movies M, Casts C
  WHERE A.aId = C.aId AND D.did = M.did AND M.mId = C.mId AND
  D.name != "Spielberg")
