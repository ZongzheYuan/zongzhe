Require Export Coq.Unicode.Utf8.
Require Import Coq.Bool.Bool.
Require Import CAS.basic. 
Close Scope nat.

(* equiv relations *) 
Definition brel_reflexive (S : Type) (r : brel S) :=
  ∀ s : S, r s s = true.

Definition brel_symmetric (S : Type) (r : brel S) := 
    ∀ s t : S, (r s t = true) → (r t s = true). 

Definition brel_transitive (S : Type) (r : brel S) := 
  ∀ s t u: S, (r s t = true) → (r t u = true) → (r s u = true).

Definition brel_congruence (S : Type) (eq : brel S) (r : brel S) := 
   ∀ s t u v : S, eq s u = true → eq t v = true → r s t = r u v. 

(* simple properties for binary operators (bops)  *) 
Definition bop_congruence (S : Type) (r : brel S) (b : binary_op S) := 
   ∀ (s1 s2 t1 t2 : S), r s1 t1 = true -> r s2 t2 = true -> r (b s1 s2) (b t1 t2) = true.

Definition bop_associative (S : Type) (r : brel S) (b : binary_op S) 
  := ∀ s t u : S, r (b (b s t) u) (b s (b t u)) = true.

(* optional semiring properties *)

(* commutativity *) 

Definition bop_commutative (S : Type) (r : brel S) (b : binary_op S) 
    := ∀ s t : S, r (b s t) (b t s) = true. 

Definition bop_not_commutative(S : Type) (r : brel S) (b : binary_op S) 
  := { z : S * S & match z with (s, t) => r (b s t) (b t s) = false end }.

Definition bop_commutative_decidable (S : Type) (r : brel S) (b : binary_op S) 
  := (bop_commutative S r b) + (bop_not_commutative S r b).

(* selectivity *) 

Definition bop_selective (S : Type) (eq : brel S) (b : binary_op S) 
    := ∀ s t : S, (eq (b s t) s = true) + (eq (b s t) t = true).

Definition bop_not_selective (S : Type) (eq : brel S) (b : binary_op S) 
    := { z : S * S & match z with (s, t) =>  (eq (b s t) s = false) * (eq (b s t) t = false) end }. 

Definition bop_selective_decidable  (S : Type) (eq : brel S) (b : binary_op S) := 
    (bop_selective S eq b) + (bop_not_selective S eq b). 


(* idempotence *)

Definition bop_idempotent (S : Type) (r : brel S) (b : binary_op S) 
    := ∀ s : S, r (b s s) s = true. 

Definition bop_not_idempotent (S : Type) (r : brel S) (b : binary_op S) 
    := {s : S & r (b s s) s = false}.

Definition bop_idempotent_decidable  (S : Type) (r : brel S) (b : binary_op S) := 
    (bop_idempotent S r b) + (bop_not_idempotent S r b). 

(* has identity *)

Definition bop_is_id (S : Type) (r : brel S) (b : binary_op S) (i : S) 
    := ∀ s : S, (r (b i s) s = true) * (r (b s i) s = true).

Definition bop_not_is_id (S : Type) (r : brel S) (b : binary_op S) (i : S)
    := {s : S & (r (b i s) s = false) + (r (b s i) s = false)}.

Definition bop_exists_id (S : Type) (r : brel S) (b : binary_op S) 
    := {i : S & bop_is_id S r b i}.

Definition bop_not_exists_id (S : Type) (r : brel S) (b : binary_op S) 
    := ∀ i : S, bop_not_is_id S r b i.

Definition bop_exists_id_decidable  (S : Type) (r : brel S) (b : binary_op S) := 
    (bop_exists_id S r b) + (bop_not_exists_id S r b). 

(* has annihilator *) 

Definition bop_is_ann (S : Type) (r : brel S) (b : binary_op S) (a : S)
    :=  ∀ s : S, (r (b a s) a = true) * (r (b s a) a = true).

Definition bop_not_is_ann (S : Type) (r : brel S) (b : binary_op S) (a : S)
    := {s : S & (r (b a s) a = false) + (r (b s a) a = false)}.

Definition bop_exists_ann (S : Type) (r : brel S) (b : binary_op S) 
    := {a : S & bop_is_ann S r b a }.

Definition bop_not_exists_ann (S : Type) (r : brel S) (b : binary_op S) 
    := ∀ a : S, bop_not_is_ann S r b a. 

Definition bop_exists_ann_decidable  (S : Type) (r : brel S) (b : binary_op S) := 
    (bop_exists_ann S r b) + (bop_not_exists_ann S r b). 

(* bisemigroup properties *)

Definition bop_left_distributive (S : Type) (r : brel S) (add : binary_op S) (mul : binary_op S) 
   := ∀ s t u : S, r (mul s (add t u)) (add (mul s t) (mul s u)) = true. 

Definition bop_right_distributive (S : Type) (r : brel S) (add : binary_op S) (mul : binary_op S) 
   := ∀ s t u : S, r (mul (add t u) s) (add (mul t s) (mul u s)) = true. 

Definition bop_not_left_distributive (S : Type) (r : brel S) (add : binary_op S) (mul : binary_op S) 
   := {a : S * S * S & match a with (s,t,u) => r (mul s (add t u)) (add (mul s t) (mul s u)) = false end}. 

Definition bop_not_right_distributive (S : Type) (r : brel S) (add : binary_op S) (mul : binary_op S) 
:= {a : S * S * S & match a with (s,t,u) => r (mul (add t u) s) (add (mul t s) (mul u s)) = false end}.

Definition bop_left_distributive_decidable (S : Type) (r : brel S) (add : binary_op S) (mul : binary_op S) 
:= bop_left_distributive S r add mul + bop_not_left_distributive S r add mul.

Definition bop_right_distributive_decidable (S : Type) (r : brel S) (add : binary_op S) (mul : binary_op S) 
:= bop_right_distributive S r add mul + bop_not_right_distributive S r add mul.

(* reduction properties *)
Definition uop_congruence (S : Type) (eq : brel S) (r : unary_op S) := 
  ∀ (s1 s2 : S), eq s1 s2 = true -> eq (r s1) (r s2) = true. 

Definition uop_idempotent (S : Type) (eq : brel S) (r : unary_op S) := 
  ∀ s : S, eq (r (r s)) (r s) = true.

Definition bop_left_uop_invariant (S : Type) (eq : brel S) (b : binary_op S) (r : unary_op S) :=
  ∀ s1 s2 : S, eq (b (r s1) s2) (b s1 s2)  = true.

Definition bop_right_uop_invariant (S : Type) (eq : brel S) (b : binary_op S) (r : unary_op S) :=
  ∀ s1 s2 : S, eq (b s1 (r s2)) (b s1 s2)  = true.

Definition uop_preserves_id (S : Type) (eq : brel S) (b : binary_op S) (r : unary_op S) :=
  ∀ (s : S), bop_is_id S eq b s -> eq (r s) s = true.

Definition uop_preserves_ann (S : Type) (eq : brel S) (b : binary_op S) (r : unary_op S) :=
  ∀ (s : S), bop_is_ann S eq b s -> eq (r s) s = true.

(* new properties added 28/03/2018 *)

Definition bop_self_divisor (S : Type) (eqS : brel S) (bS : binary_op S) (aS : S) :=
  ∀ a b : S, eqS (bS a b) aS = true → (eqS a aS = true) + (eqS b aS = true).

Definition bop_self_square (S : Type) (eqS : brel S) (bS : binary_op S) (aS : S) :=
  ∀ a b : S, eqS (bS a b) aS = true → (eqS a aS = true) * (eqS b aS = true).

(* new property, 3/4/2018 *)
(*
      r(r(s) + r(t)) +  r(u)  =_r  r(s) + r(r(t) + r(u)) 
*) 
Definition bop_pseudo_associative (S : Type) (eq : brel S) (r : unary_op S) (b : binary_op S) 
  := ∀ s t u : S, eq (r (b (r (b (r s) (r t))) (r u))) (r (b (r s) (r (b (r t) (r u))))) = true.

(* predicate-related properties.  added 16/4/2018 *)

Definition pred_true (S : Type) (P : pred S) (s : S) 
  := P s = true. 

Definition pred_congruence (S : Type) (eq : brel S) (P : pred S) 
  := ∀ (a b : S), eq a b = true -> P a = P b.

Definition pred_bop_decompose (S : Type) (P : pred S) (bS : binary_op S) 
  := ∀ (a b : S), P (bS a b) = true -> (P a = true) + (P b = true).

Definition pred_bop_compose (S : Type) (P : pred S) (bS : binary_op S) 
  := ∀ (a b : S), (P a = true) + (P b = true) -> P (bS a b) = true.

Definition pred_preserve_order (S : Type) (P : pred S) (eqS : brel S) (bS : binary_op S)
  := ∀ (a b : S), eqS (bS a b) a = true -> P a = true -> P b = true.