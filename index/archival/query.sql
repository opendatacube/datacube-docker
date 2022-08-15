update agdc.dataset
set archived = NULL
where dataset_type_ref = (select id from agdc.dataset_type where name = :'product_name')
AND(
    (
        metadata -> 'extent' ->> 'center_dt' LIKE '%2010%'
    )
    OR (
        metadata -> 'extent' ->> 'center_dt' LIKE '%2015%'
    )
);