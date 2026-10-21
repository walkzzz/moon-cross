///|
/// 证明结果 | Proof result
pub(all) struct ProofResult {
  name : String
  holds : Bool
  message : String
} derive(Debug, Eq)
pub extend ProofResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ProofResult with Eq::{not_equal, equal}

///|
/// 契约 | Contract (precondition + postcondition)
pub(all) struct Contract {
  name : String
  pre_condition : String
  post_condition : String
} derive(Debug, Eq)
pub extend Contract with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Contract with Eq::{not_equal, equal}

///|
/// 不变量 | Invariant
pub(all) struct Invariant {
  name : String
  description : String
  check : Bool
} derive(Debug, Eq)
pub extend Invariant with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Invariant with Eq::{not_equal, equal}

///|
/// 创建证明结果 | Create proof result
pub fn proof_result(name : String, holds : Bool, message : String) -> ProofResult {
  { name, holds, message, }
}

///|
/// 创建契约 | Create contract
pub fn contract_create(name : String, pre : String, post : String) -> Contract {
  { name, pre_condition: pre, post_condition: post, }
}

///|
/// 创建不变量 | Create invariant
pub fn invariant_create(name : String, desc : String, check : Bool) -> Invariant {
  { name, description: desc, check, }
}

///|
/// 验证契约 | Verify contract
pub fn contract_verify(contract : Contract, pre_holds : Bool, post_holds : Bool) -> ProofResult {
  if pre_holds && post_holds {
    { name: contract.name, holds: true, message: "contract satisfied", }
  } else if !pre_holds {
    { name: contract.name, holds: false, message: "precondition failed: " + contract.pre_condition, }
  } else {
    { name: contract.name, holds: false, message: "postcondition failed: " + contract.post_condition, }
  }
}

///|
/// 检查不变量 | Check invariant
pub fn invariant_check(inv : Invariant) -> ProofResult {
  if inv.check {
    { name: inv.name, holds: true, message: "invariant holds: " + inv.description, }
  } else {
    { name: inv.name, holds: false, message: "invariant violated: " + inv.description, }
  }
}

///|
/// 性质成立检查 | Property holds check
pub fn property_holds(name : String, check : Bool) -> ProofResult {
  { name, holds: check, message: if check { "property holds" } else { "property does not hold" }, }
}

///|
/// 证明链 | Proof chain (all must hold)
pub fn proof_chain(results : Array[ProofResult]) -> ProofResult {
  let mut all_holds = true
  let mut failed_name = ""
  for r in results {
    if !r.holds {
      all_holds = false
      failed_name = r.name
    }
  }
  if all_holds {
    { name: "chain", holds: true, message: "all " + results.length().to_string() + " proofs hold", }
  } else {
    { name: "chain", holds: false, message: "failed at: " + failed_name, }
  }
}

///|
/// 排序不变量：排序后长度不变 | Sorted invariant: length preserved
pub fn length_preserved(original : Array[Int], sorted : Array[Int]) -> ProofResult {
  let holds = original.length() == sorted.length()
  { name: "length_preserved", holds, message: if holds { "lengths match" } else { "lengths differ: " + original.length().to_string() + " vs " + sorted.length().to_string() }, }
}

///|
/// 排序不变量：元素有序 | Sorted invariant: elements ordered
pub fn is_sorted(arr : Array[Int]) -> ProofResult {
  let mut holds = true
  for i in 1..<arr.length() {
    if arr[i] < arr[i - 1] {
      holds = false
    }
  }
  { name: "is_sorted", holds, message: if holds { "array is sorted" } else { "array not sorted" }, }
}

///|
/// 幂等性检查 | Idempotent check: f(f(x)) == f(x)
pub fn idempotent_check(name : String, _x : Int, fx : Int, ffx : Int) -> ProofResult {
  let holds = fx == ffx
  { name: "idempotent_" + name, holds, message: if holds { "f(f(x)) == f(x)" } else { "f(f(x)) != f(x): " + ffx.to_string() + " vs " + fx.to_string() }, }
}

///|
/// 交换律检查 | Commutative check: a op b == b op a
pub fn commutative_check(name : String, _a : Int, _b : Int, ab : Int, ba : Int) -> ProofResult {
  let holds = ab == ba
  { name: "commutative_" + name, holds, message: if holds { "a op b == b op a" } else { "not commutative" }, }
}

///|
/// 结合律检查 | Associative check: (a op b) op c == a op (b op c)
pub fn associative_check(name : String, ab_c : Int, a_bc : Int) -> ProofResult {
  let holds = ab_c == a_bc
  { name: "associative_" + name, holds, message: if holds { "(a op b) op c == a op (b op c)" } else { "not associative" }, }
}

///|
/// 加密解密互逆 | Encrypt-decrypt inverse: decrypt(encrypt(x)) == x
pub fn inverse_check(name : String, original : Int, _encrypted : Int, decrypted : Int) -> ProofResult {
  let holds = original == decrypted
  { name: "inverse_" + name, holds, message: if holds { "decrypt(encrypt(x)) == x" } else { "inverse failed: " + decrypted.to_string() + " != " + original.to_string() }, }
}

///|
/// 单位元检查 | Identity check: x op identity == x
pub fn identity_check(name : String, x : Int, _identity : Int, result : Int) -> ProofResult {
  let holds = x == result
  { name: "identity_" + name, holds, message: if holds { "x op identity == x" } else { "identity check failed" }, }
}

///|
/// 范围不变量 | Range invariant: min <= x <= max
pub fn range_invariant(name : String, x : Int, min_val : Int, max_val : Int) -> ProofResult {
  let holds = x >= min_val && x <= max_val
  { name: "range_" + name, holds, message: if holds { "in range [" + min_val.to_string() + ", " + max_val.to_string() + "]" } else { "out of range: " + x.to_string() }, }
}

///|
/// 证明包版本 | Proof package version
pub fn proof_version() -> String {
  "moon-cross proof v0.3.3"
}

///|
/// ProofResult 实现 Named trait | ProofResult implements Named
pub impl @trait.Named for ProofResult with name(self) {
  self.name
}
pub extend ProofResult with @trait.Named::{name}

///|
/// ProofResult 实现 Checkable trait | ProofResult implements Checkable
pub impl @trait.Checkable for ProofResult with check(self) {
  self.holds
}
pub extend ProofResult with @trait.Checkable::{check}

///|
/// ProofResult 实现 Summarizable trait | ProofResult implements Summarizable
pub impl @trait.Summarizable for ProofResult with summary(self) {
  self.name + ": " + (if self.holds { "holds" } else { "fails" }) + " — " + self.message
}
pub extend ProofResult with @trait.Summarizable::{summary}

///|
/// Contract 实现 Named trait | Contract implements Named
pub impl @trait.Named for Contract with name(self) {
  self.name
}
pub extend Contract with @trait.Named::{name}

///|
/// Contract 实现 Describable trait | Contract implements Describable
pub impl @trait.Describable for Contract with describe(self) {
  "pre: " + self.pre_condition + ", post: " + self.post_condition
}
pub extend Contract with @trait.Describable::{describe}

///|
/// Invariant 实现 Named trait | Invariant implements Named
pub impl @trait.Named for Invariant with name(self) {
  self.name
}
pub extend Invariant with @trait.Named::{name}

///|
/// Invariant 实现 Describable trait | Invariant implements Describable
pub impl @trait.Describable for Invariant with describe(self) {
  self.description
}
pub extend Invariant with @trait.Describable::{describe}

///|
/// Invariant 实现 Checkable trait | Invariant implements Checkable
pub impl @trait.Checkable for Invariant with check(self) {
  self.check
}
pub extend Invariant with @trait.Checkable::{check}