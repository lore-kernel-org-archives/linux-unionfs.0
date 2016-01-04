Return-Path: <leisurelysw24@gmail.com>
MIME-Version: 1.0
Date: Mon, 4 Jan 2016 13:03:02 +0800
Message-ID: <CAKQB+fuYbWHm+CiYHDycrre5RZdCVKPRuqz83FnkGF2_0siz8w@mail.gmail.com>
Subject: Question about the restrictions on overlayfs
From: Jerry Lee <leisurelysw24@gmail.com>
Content-Type: multipart/alternative; boundary=001a1139784c194c2005287b0969
To: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, mszeredi@suse.cz
List-ID: <linux-unionfs@vger.kernel.org>

--001a1139784c194c2005287b0969
Content-Type: text/plain; charset=UTF-8

Hi,

I have a question about the restrictions on overlayfs.  When mounting
overlayfs, it
uses the ovl_dentry_weird() function to check whether the dentries on the
upper file
system has some dentry operations defined.  Here's the code:

static bool ovl_dentry_weird(struct dentry *dentry)
{
       return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
                                 DCACHE_MANAGE_TRANSIT |
                                 DCACHE_OP_HASH |
                                 DCACHE_OP_COMPARE);
}

What is the reason that overlayfs needs to forbid mounting on a file system
with
dentry operations?  Is it just to avoid mounting a case-insensitive file
system?


Thanks.

--001a1139784c194c2005287b0969
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdj48ZGl2PkhpLDxicj48YnI+PC9kaXY+SSBoYXZlIGEgcXVlc3Rp
b24gYWJvdXQgdGhlIHJlc3RyaWN0aW9ucyBvbiBvdmVybGF5ZnMuwqAgV2hlbiBtb3VudGluZyBv
dmVybGF5ZnMsIGl0IDxicj51c2VzIHRoZSBvdmxfZGVudHJ5X3dlaXJkKCkgZnVuY3Rpb24gdG8g
Y2hlY2sgd2hldGhlciB0aGUgZGVudHJpZXMgb24gdGhlIHVwcGVyIGZpbGUgPGJyPjwvZGl2Pjxk
aXY+c3lzdGVtIGhhcyBzb21lIGRlbnRyeSBvcGVyYXRpb25zIGRlZmluZWQuwqAgSGVyZSYjMzk7
cyB0aGUgY29kZTo8YnI+PC9kaXY+PGRpdj48YnI+c3RhdGljIGJvb2wgb3ZsX2RlbnRyeV93ZWly
ZChzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpPGJyPns8YnI+wqDCoMKgwqDCoMKgIHJldHVybiBkZW50
cnktJmd0O2RfZmxhZ3MgJmFtcDsgKERDQUNIRV9ORUVEX0FVVE9NT1VOVCB8PGJyPsKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
RENBQ0hFX01BTkFHRV9UUkFOU0lUIHw8YnI+wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBEQ0FDSEVfT1BfSEFTSCB8PGJyPsKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgRENBQ0hFX09QX0NPTVBBUkUpOzxicj59PGJyPjxicj48L2Rpdj48ZGl2PldoYXQgaXMg
dGhlIHJlYXNvbiB0aGF0IG92ZXJsYXlmcyBuZWVkcyB0byBmb3JiaWQgbW91bnRpbmcgb24gYSBm
aWxlIHN5c3RlbSB3aXRoIDxicj48L2Rpdj48ZGl2PmRlbnRyeSBvcGVyYXRpb25zP8KgIElzIGl0
IGp1c3QgdG8gYXZvaWQgbW91bnRpbmcgYSBjYXNlLWluc2Vuc2l0aXZlIGZpbGUgc3lzdGVtPzxi
cj48L2Rpdj48ZGl2Pjxicj48YnI+PC9kaXY+PGRpdj48L2Rpdj48ZGl2PlRoYW5rcy48YnI+IDwv
ZGl2PjwvZGl2Pg0K
--001a1139784c194c2005287b0969--
