From: Roman Yeryomin <leroi.lists@gmail.com>
Subject: Re: [OpenWrt-Devel] Device tree issues with TL-WDR4900 (mpc85xx) and
 kernel 4.0.1
Date: Mon, 15 Jun 2015 18:11:05 +0300
Message-ID: <CACiydbJUe2Jda5jzJxuxogajEk+pWR4a+uS5jBwRedQO_Q2WMg@mail.gmail.com>
References: <CAJfpegvbBWmxouP=vt7e7_W38TGWcbOcHnUOifuzFhOsjhYKag@mail.gmail.com>
	<557E8BBC.8090901@openwrt.org>
	<20150615125238.GA1969@tucsk.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b15a349e598ba05188fdd0d
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33277 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbbFOPLG (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 15 Jun 2015 11:11:06 -0400
Received: by padev16 with SMTP id ev16so67521053pad.0
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2015 08:11:05 -0700 (PDT)
In-Reply-To: <20150615125238.GA1969@tucsk.suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Felix Fietkau <nbd@openwrt.org>, Wojciech Dubowik <Wojciech.Dubowik@neratec.com>, Heiner Kallweit <hkallweit1@gmail.com>, OpenWrt Development List <openwrt-devel@lists.openwrt.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

--047d7b15a349e598ba05188fdd0d
Content-Type: text/plain; charset=UTF-8

On 15 June 2015 at 15:52, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Jun 15, 2015 at 10:24:28AM +0200, Felix Fietkau wrote:
>> On 2015-06-15 10:20, Miklos Szeredi wrote:
>> > On Thu, Jun 11, 2015 at 2:01 PM, Miklos Szeredi <mszeredi@suse.cz> wrote:
>> >> On 7 May 2015 at 15:49, Felix Fietkau <nbd@openwrt.org> wrote:
>> >>> On 2015-05-07 08:01, Wojciech Dubowik wrote:
>> >>>> Try to boot with kernel locking enabled. I have seen jffs2 deadlocks on
>> >>>> readdir. As far as I remember
>> >>>> with this patch it went through but I don't know anymore whether I have
>> >>>> changed sth in config.
>> >>>>
>> >>>> Have a look at (search engine...) [PATCH] fs: jffs2: Add setup code for
>> >>>> spi nor flash.
>> >>>>
>> >>>> Even with this patch I got some possible dead lock warnings so it might
>> >>>> be just a partial cure. BTW it's
>> >>>> a bit scary for future use. Looks like jffs2 doesn't get enough care...
>> >>> I believe the locking issues are an overlayfs regression, maybe even
>> >>> the same one as this one (which I fixed years ago):
>> >>> http://linux-fsdevel.vger.kernel.narkive.com/XRtXLDlf/patch-1-2-overlayfs-fix-a-deadlock-in-ovl-dir-read-merged
>> >>>
>> >>> I believe this is the cause of the regression:
>> >>>
>> >>> commit 49c21e1cacd74a8c83407c70ad860c994e606e25
>> >>> Author: Miklos Szeredi <mszeredi@suse.cz>
>> >>> Date:   Sat Dec 13 00:59:42 2014 +0100
>> >>>
>> >>
>> >> I'm working on 4.0 support for ar71xx and found that
>> >> /etc/rc.d/S00sysfixtime is not able to finish it's job after second
>> >> boot after flashing (t.i. after overlayfs is switched to jffs). I've
>> >> run strace and found that find hangs on the very last getdents64 call
>> >> (before calling it succesfully many times on previous
>> >> files/directories).
>> >> I've reverted every change up to
>> >> 49c21e1cacd74a8c83407c70ad860c994e606e25 to overlayfs and it started
>> >> working. Applying 49c21e1cacd74a8c83407c70ad860c994e606e25 back breaks
>> >> it. So this commit is indeed the cause of regression.
>> >>
>> >> Miklos, any ideas how to fix it in current tree? I'm using 4.0.5 now
>> >> but AFAIK there were no more changes to overlayfs.
>> >
>> > What's the full mount setup?  (cat /proc/mounts)
>> /dev/root /rom squashfs ro,relatime 0 0
>> proc /proc proc rw,noatime 0 0
>> sysfs /sys sysfs rw,noatime 0 0
>> tmpfs /tmp tmpfs rw,nosuid,nodev,noatime 0 0
>> /dev/mtdblock8 /overlay jffs2 rw,noatime 0 0
>> overlayfs:/overlay / overlay rw,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work 0 0
>> tmpfs /dev tmpfs rw,relatime,size=512k,mode=755 0 0
>> devpts /dev/pts devpts rw,relatime,mode=600 0 0
>> debugfs /sys/kernel/debug debugfs rw,noatime 0 0
>>
>> - Felix
>
>
> Following patch should fix the locking issue.
>
> Please test.
>

It worked! Thanks Miklos!
Felix, attaching tested and ready to commit patch.
Or do you want me to send it separately to the list?

Regards,
Roman

--047d7b15a349e598ba05188fdd0d
Content-Type: text/x-patch; charset=US-ASCII; name="999-ovl-fix-readdir.patch"
Content-Disposition: attachment; filename="999-ovl-fix-readdir.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iay1fe0h0

LS0tIGEvZnMvb3ZlcmxheWZzL3JlYWRkaXIuYworKysgYi9mcy9vdmVybGF5ZnMvcmVhZGRpci5j
CkBAIC0yMyw2ICsyMyw3IEBAIHN0cnVjdCBvdmxfY2FjaGVfZW50cnkgewogCXU2NCBpbm87CiAJ
c3RydWN0IGxpc3RfaGVhZCBsX25vZGU7CiAJc3RydWN0IHJiX25vZGUgbm9kZTsKKwlzdHJ1Y3Qg
b3ZsX2NhY2hlX2VudHJ5ICpuZXh0X21heWJlX3doaXRlb3V0OwogCWJvb2wgaXNfd2hpdGVvdXQ7
CiAJY2hhciBuYW1lW107CiB9OwpAQCAtMzksNyArNDAsNyBAQCBzdHJ1Y3Qgb3ZsX3JlYWRkaXJf
ZGF0YSB7CiAJc3RydWN0IHJiX3Jvb3Qgcm9vdDsKIAlzdHJ1Y3QgbGlzdF9oZWFkICpsaXN0Owog
CXN0cnVjdCBsaXN0X2hlYWQgbWlkZGxlOwotCXN0cnVjdCBkZW50cnkgKmRpcjsKKwlzdHJ1Y3Qg
b3ZsX2NhY2hlX2VudHJ5ICpmaXJzdF9tYXliZV93aGl0ZW91dDsKIAlpbnQgY291bnQ7CiAJaW50
IGVycjsKIH07CkBAIC03OSw3ICs4MCw3IEBAIHN0YXRpYyBzdHJ1Y3Qgb3ZsX2NhY2hlX2VudHJ5
ICpvdmxfY2FjaGUKIAlyZXR1cm4gTlVMTDsKIH0KIAotc3RhdGljIHN0cnVjdCBvdmxfY2FjaGVf
ZW50cnkgKm92bF9jYWNoZV9lbnRyeV9uZXcoc3RydWN0IGRlbnRyeSAqZGlyLAorc3RhdGljIHN0
cnVjdCBvdmxfY2FjaGVfZW50cnkgKm92bF9jYWNoZV9lbnRyeV9uZXcoc3RydWN0IG92bF9yZWFk
ZGlyX2RhdGEgKnJkZCwKIAkJCQkJCSAgIGNvbnN0IGNoYXIgKm5hbWUsIGludCBsZW4sCiAJCQkJ
CQkgICB1NjQgaW5vLCB1bnNpZ25lZCBpbnQgZF90eXBlKQogewpAQCAtOTgsMjkgKzk5LDggQEAg
c3RhdGljIHN0cnVjdCBvdmxfY2FjaGVfZW50cnkgKm92bF9jYWNoZQogCXAtPmlzX3doaXRlb3V0
ID0gZmFsc2U7CiAKIAlpZiAoZF90eXBlID09IERUX0NIUikgewotCQlzdHJ1Y3QgZGVudHJ5ICpk
ZW50cnk7Ci0JCWNvbnN0IHN0cnVjdCBjcmVkICpvbGRfY3JlZDsKLQkJc3RydWN0IGNyZWQgKm92
ZXJyaWRlX2NyZWQ7Ci0KLQkJb3ZlcnJpZGVfY3JlZCA9IHByZXBhcmVfY3JlZHMoKTsKLQkJaWYg
KCFvdmVycmlkZV9jcmVkKSB7Ci0JCQlrZnJlZShwKTsKLQkJCXJldHVybiBOVUxMOwotCQl9Ci0K
LQkJLyoKLQkJICogQ0FQX0RBQ19PVkVSUklERSBmb3IgbG9va3VwCi0JCSAqLwotCQljYXBfcmFp
c2Uob3ZlcnJpZGVfY3JlZC0+Y2FwX2VmZmVjdGl2ZSwgQ0FQX0RBQ19PVkVSUklERSk7Ci0JCW9s
ZF9jcmVkID0gb3ZlcnJpZGVfY3JlZHMob3ZlcnJpZGVfY3JlZCk7Ci0KLQkJZGVudHJ5ID0gbG9v
a3VwX29uZV9sZW4obmFtZSwgZGlyLCBsZW4pOwotCQlpZiAoIUlTX0VSUihkZW50cnkpKSB7Ci0J
CQlwLT5pc193aGl0ZW91dCA9IG92bF9pc193aGl0ZW91dChkZW50cnkpOwotCQkJZHB1dChkZW50
cnkpOwotCQl9Ci0JCXJldmVydF9jcmVkcyhvbGRfY3JlZCk7Ci0JCXB1dF9jcmVkKG92ZXJyaWRl
X2NyZWQpOworCQlwLT5uZXh0X21heWJlX3doaXRlb3V0ID0gcmRkLT5maXJzdF9tYXliZV93aGl0
ZW91dDsKKwkJcmRkLT5maXJzdF9tYXliZV93aGl0ZW91dCA9IHA7CiAJfQogCXJldHVybiBwOwog
fQpAQCAtMTQ4LDcgKzEyOCw3IEBAIHN0YXRpYyBpbnQgb3ZsX2NhY2hlX2VudHJ5X2FkZF9yYihz
dHJ1Y3QKIAkJCXJldHVybiAwOwogCX0KIAotCXAgPSBvdmxfY2FjaGVfZW50cnlfbmV3KHJkZC0+
ZGlyLCBuYW1lLCBsZW4sIGlubywgZF90eXBlKTsKKwlwID0gb3ZsX2NhY2hlX2VudHJ5X25ldyhy
ZGQsIG5hbWUsIGxlbiwgaW5vLCBkX3R5cGUpOwogCWlmIChwID09IE5VTEwpCiAJCXJldHVybiAt
RU5PTUVNOwogCkBAIC0xNjksNyArMTQ5LDcgQEAgc3RhdGljIGludCBvdmxfZmlsbF9sb3dlcihz
dHJ1Y3Qgb3ZsX3JlYQogCWlmIChwKSB7CiAJCWxpc3RfbW92ZV90YWlsKCZwLT5sX25vZGUsICZy
ZGQtPm1pZGRsZSk7CiAJfSBlbHNlIHsKLQkJcCA9IG92bF9jYWNoZV9lbnRyeV9uZXcocmRkLT5k
aXIsIG5hbWUsIG5hbWVsZW4sIGlubywgZF90eXBlKTsKKwkJcCA9IG92bF9jYWNoZV9lbnRyeV9u
ZXcocmRkLCBuYW1lLCBuYW1lbGVuLCBpbm8sIGRfdHlwZSk7CiAJCWlmIChwID09IE5VTEwpCiAJ
CQlyZGQtPmVyciA9IC1FTk9NRU07CiAJCWVsc2UKQEAgLTIxOSw2ICsxOTksNDMgQEAgc3RhdGlj
IGludCBvdmxfZmlsbF9tZXJnZShzdHJ1Y3QgZGlyX2NvbgogCQlyZXR1cm4gb3ZsX2ZpbGxfbG93
ZXIocmRkLCBuYW1lLCBuYW1lbGVuLCBvZmZzZXQsIGlubywgZF90eXBlKTsKIH0KIAorc3RhdGlj
IGludCBvdmxfY2hlY2tfd2hpdGVvdXRzKHN0cnVjdCBkZW50cnkgKmRpciwgc3RydWN0IG92bF9y
ZWFkZGlyX2RhdGEgKnJkZCkKK3sKKwlpbnQgZXJyID0gMDsKKworCW11dGV4X2xvY2soJmRpci0+
ZF9pbm9kZS0+aV9tdXRleCk7CisJd2hpbGUgKHJkZC0+Zmlyc3RfbWF5YmVfd2hpdGVvdXQpIHsK
KwkJc3RydWN0IGRlbnRyeSAqZGVudHJ5OworCQljb25zdCBzdHJ1Y3QgY3JlZCAqb2xkX2NyZWQ7
CisJCXN0cnVjdCBjcmVkICpvdmVycmlkZV9jcmVkOworCQlzdHJ1Y3Qgb3ZsX2NhY2hlX2VudHJ5
ICpwID0gcmRkLT5maXJzdF9tYXliZV93aGl0ZW91dDsKKworCQlyZGQtPmZpcnN0X21heWJlX3do
aXRlb3V0ID0gcC0+bmV4dF9tYXliZV93aGl0ZW91dDsKKworCQlvdmVycmlkZV9jcmVkID0gcHJl
cGFyZV9jcmVkcygpOworCQlpZiAoIW92ZXJyaWRlX2NyZWQpIHsKKwkJCWVyciA9IC1FTk9NRU07
CisJCQlicmVhazsKKwkJfQorCQkvKgorCQkgKiBDQVBfREFDX09WRVJSSURFIGZvciBsb29rdXAK
KwkJICovCisJCWNhcF9yYWlzZShvdmVycmlkZV9jcmVkLT5jYXBfZWZmZWN0aXZlLCBDQVBfREFD
X09WRVJSSURFKTsKKwkJb2xkX2NyZWQgPSBvdmVycmlkZV9jcmVkcyhvdmVycmlkZV9jcmVkKTsK
KworCQlkZW50cnkgPSBsb29rdXBfb25lX2xlbihwLT5uYW1lLCBkaXIsIHAtPmxlbik7CisJCWlm
ICghSVNfRVJSKGRlbnRyeSkpIHsKKwkJCXAtPmlzX3doaXRlb3V0ID0gb3ZsX2lzX3doaXRlb3V0
KGRlbnRyeSk7CisJCQlkcHV0KGRlbnRyeSk7CisJCX0KKwkJcmV2ZXJ0X2NyZWRzKG9sZF9jcmVk
KTsKKwkJcHV0X2NyZWQob3ZlcnJpZGVfY3JlZCk7CisJfQorCW11dGV4X3VubG9jaygmZGlyLT5k
X2lub2RlLT5pX211dGV4KTsKKworCXJldHVybiBlcnI7Cit9CisKIHN0YXRpYyBpbmxpbmUgaW50
IG92bF9kaXJfcmVhZChzdHJ1Y3QgcGF0aCAqcmVhbHBhdGgsCiAJCQkgICAgICAgc3RydWN0IG92
bF9yZWFkZGlyX2RhdGEgKnJkZCkKIHsKQEAgLTIyOSw3ICsyNDYsNyBAQCBzdGF0aWMgaW5saW5l
IGludCBvdmxfZGlyX3JlYWQoc3RydWN0IHBhCiAJaWYgKElTX0VSUihyZWFsZmlsZSkpCiAJCXJl
dHVybiBQVFJfRVJSKHJlYWxmaWxlKTsKIAotCXJkZC0+ZGlyID0gcmVhbHBhdGgtPmRlbnRyeTsK
KwlyZGQtPmZpcnN0X21heWJlX3doaXRlb3V0ID0gTlVMTDsKIAlyZGQtPmN0eC5wb3MgPSAwOwog
CWRvIHsKIAkJcmRkLT5jb3VudCA9IDA7CkBAIC0yMzgsNiArMjU1LDEwIEBAIHN0YXRpYyBpbmxp
bmUgaW50IG92bF9kaXJfcmVhZChzdHJ1Y3QgcGEKIAkJaWYgKGVyciA+PSAwKQogCQkJZXJyID0g
cmRkLT5lcnI7CiAJfSB3aGlsZSAoIWVyciAmJiByZGQtPmNvdW50KTsKKworCWlmICghZXJyICYm
IHJkZC0+Zmlyc3RfbWF5YmVfd2hpdGVvdXQpCisJCWVyciA9IG92bF9jaGVja193aGl0ZW91dHMo
cmVhbHBhdGgtPmRlbnRyeSwgcmRkKTsKKwogCWZwdXQocmVhbGZpbGUpOwogCiAJcmV0dXJuIGVy
cjsK
--047d7b15a349e598ba05188fdd0d--
