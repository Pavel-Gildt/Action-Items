declare
    new_rel_id         relation_type.relation_type_id%type;
    v_project_tid       xitor_type.xitor_type_id%type;
    v_action_item_tid   xitor_type.xitor_type_id%type;
    
    v_is_in_tree number;
begin
    

    
    select xitor_type_id
    into v_project_tid
    from xitor_type
    where upper(XITOR_TYPE) = 'PROJECT';
    
    select xitor_type_id
    into v_action_item_tid
    from xitor_type
    where upper(XITOR_TYPE) = 'ACTION_ITEMS';
    
    select count(1)
    into v_is_in_tree
    from relation_type 
    where child_type_id = v_project_tid
    and rownum = 1;
    
    if v_is_in_tree = 0 then
        new_rel_id := pkg_relation.new_relation_type(pid             => null,
                                                     cid             => v_project_tid,
                                                     cardinality     => 2,
                                                     childreqparent  => 1,
                                                     onDeleteCascade => 1,
                                                     uniqueBy        => v_project_tid);
        commit;
    end if;
    
    select count(1)
    into v_is_in_tree
    from relation_type 
    where child_type_id = v_action_item_tid
    and rownum = 1;
    
    new_rel_id := pkg_relation.new_relation_type(pid             => v_project_tid,
                                                 cid             => v_action_item_tid,
                                                 cardinality     => 2,
                                                 childreqparent  => 1,
                                                 onDeleteCascade => 1,
                                                 uniqueBy        => v_action_item_tid);
    commit;
end;
