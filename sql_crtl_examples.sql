--main query
select count(*) result 
from lu_policies pol,lu_claims cl
where pol.active_member = 'Y'
and   pol.policy_id = cl.policy_id
and   pol.member_age != cl.member_age
and exists (select 1 from extracted_claims ex 
			where ex.claim_id = cl.claim_id);

--detail query
select policy_id  ID1
	  ,member_id  ID2
	  ,NULL		  ID3
	  ,NULL       ID4
	  ,pol.member_age RESULT1
	  ,cl.member_age  RESULT2
	  ,abs(pol.member_age-cl.member_age) RESULT3
from lu_policies pol,lu_claims cl
where pol.active_member = 'Y'
and   pol.policy_id = cl.policy_id
and   pol.member_age != cl.member_age
and exists (select 1 from extracted_claims ex 
			where ex.claim_id = cl.claim_id);