CREATE DEFINER = CURRENT_USER TRIGGER `classicmodels`.`emp_eh_BEFORE_INSERT` BEFORE INSERT ON `emp_eh` FOR EACH ROW
BEGIN
if Working_Hours< 0 then set new.Working_Hours= -new.Working_Hours;
end if;
END