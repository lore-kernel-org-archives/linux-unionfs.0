From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Fri, 5 May 2017 10:25:39 +0300
Message-ID: <CAOQ4uxitv9FcZO9Ch-3dx0vPZTpZMxcRo=WmCRxj7fUqNJqCGg@mail.gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
 <CAJfpegs4SnbHVTa43Wy9R=_3XRMwwnXN9SCKCpq42F-19g9LnQ@mail.gmail.com>
 <CAOQ4uxi4sjY=q4q=kU7vtJEKASUwO9DE3Xa61GMe9wEOHQ-f1g@mail.gmail.com>
 <CAOQ4uxgprhDhRzWyTEYUaYKdvUeYWNSafreu1r3TA-2r7xg-aA@mail.gmail.com>
 <CAJfpegss1jrd0LZkCOkaiQe06ECwH0atneVg3xa_YWXiG4UDOw@mail.gmail.com>
 <CAJfpeguVxbEQLqnz6t1sjbG5J5hWpqgqOw7qdtEZGSxd7j+y4A@mail.gmail.com>
 <CAOQ4uxiwumOLyVgzoT4pR_Lv08aGreZQNN-xW4OEpYCyxBHffg@mail.gmail.com>
 <CAOQ4uxi_h8cs67GyT3XnnQD0CoZEAA-TqBiTCsjPxHGxN9ZK7A@mail.gmail.com>
 <CAJfpegsDnUuPped_LJY_QfS1zqqoQ5=dW5H5yjU55mxkAawHCQ@mail.gmail.com>
 <CAOQ4uxiYF3QxB2ksQRJDqSrxJ3Lm8MfEe8AF+mp0v7dBrSopLA@mail.gmail.com> <CAJfpegtZHOO2oB8YSeQoEHiXK-aTYOw_083riABQmiZ_75m92Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=94eb2c03b810ec3cfc054ec1cbcf
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36548 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752141AbdEEHZl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 May 2017 03:25:41 -0400
In-Reply-To: <CAJfpegtZHOO2oB8YSeQoEHiXK-aTYOw_083riABQmiZ_75m92Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

--94eb2c03b810ec3cfc054ec1cbcf
Content-Type: text/plain; charset=UTF-8

On Fri, May 5, 2017 at 12:03 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, May 4, 2017 at 4:14 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> One minor review comment.
>>
>> I used uuid_le_cmp(*uuid, NULL_UUID_LE) arbitrarily in my original patch,
>> but if we want to stick to semantic sb->s_uuid is probably more accurately
>> described as uuid_be, because filesystems most likely copy it in raw format
>> from disk.
>>
>> This is purely semantic of course, but if you think that matters, may as well
>> replace uuid_le with uuid_be.
>
> Okay.
>
> More changes:
>
>   - use vfs_getattr() to get the lower inode number instead of
> lower->d_inode->i_ino.  For one i_ino is 32bit on 32bit archs, while
> kstat.ino is always 64bit
>
>   - merge the dir and non-dir getattr, they look very similar now

Nice, see suggestion below for 'improvement'.

You also forgot to mention in changes since v6:

   - store 'null' fh instead of 'invalid' fh

Reviewed and tested v7.

Regarding ovl_getattr(), it is a good example for code that could make
use of OVL_TYPE_COPYUP() for better readability.

OVL_TYPE_COPYUP() was originally meant to mark also dentries
with null origin fh, but it is useful IMO also to mark dentries for which
we hold an origin (and maybe grow the original meaning later).

Attached a patch to add OVL_TYPE_COPYUP() with diminished
interpretation, which also makes use of it in ovl_getattr().
If you take that patch, you probably want to apply it before the
ovl_getattr() change though.

BTW, I tested with that patch.

Cheers,
Amir.

--94eb2c03b810ec3cfc054ec1cbcf
Content-Type: text/x-patch; charset=US-ASCII;
	name="v7-0001-ovl-set-the-COPYUP-type-flag-for-non-dirs.patch"
Content-Disposition: attachment;
	filename="v7-0001-ovl-set-the-COPYUP-type-flag-for-non-dirs.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j2bigjfj0

RnJvbSBjYjBiNmRhY2VmM2NmM2IxYzY1NDU5ZDE3NGRiMjM5MjA5NWRhOWZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBTdW4sIDIzIEFwciAyMDE3IDIzOjEyOjM0ICswMzAwClN1YmplY3Q6IFtQQVRDSCB2N10g
b3ZsOiBzZXQgdGhlIENPUFlVUCB0eXBlIGZsYWcgZm9yIG5vbi1kaXJzCgpGb3IgZGlyZWN0b3J5
IGVudHJpZXMsIG5vbiB6ZXJvIG9lLT5udW1sb3dlciBpbXBsaWVzIE9WTF9UWVBFX01FUkdFLgpE
ZWZpbmUgYSBuZXcgdHlwZSBmbGFnIE9WTF9UWVBFX0NPUFlVUCB0byBpbmRpY2F0ZSB0aGF0IGFu
IGVudHJ5IGhvbGRzCmEgcmVmZXJlbmNlIHRvIGl0cyBsb3dlciBjb3B5IHVwIG9yaWdpbi4KCkZv
ciBkaXJlY3RvcnkgZW50cmllcyBDT1BZVVAgOj0gTUVSR0UgJiYgVVBQRVIuIEZvciBub24tZGly
IGVudHJpZXMKQ09QWVVQIG1lYW5zIHRoYXQgYSBsb3dlciB0eXBlIGRlbnRyeSBoYXMgYmVlbiBy
ZWNlbnRseSBjb3BpZWQgdXAgb3IKdGhhdCB3ZSB3ZXJlIGFibGUgdG8gZmluZCB0aGUgY29weSB1
cCBvcmlnaW4gZnJvbSBvdmVybGF5LmZoIHhhdHRyLgoKU2lnbmVkLW9mZi1ieTogQW1pciBHb2xk
c3RlaW4gPGFtaXI3M2lsQGdtYWlsLmNvbT4KLS0tCiBmcy9vdmVybGF5ZnMvaW5vZGUuYyAgICAg
fCAgNSArKy0tLQogZnMvb3ZlcmxheWZzL292ZXJsYXlmcy5oIHwgIDIgKysKIGZzL292ZXJsYXlm
cy91dGlsLmMgICAgICB8IDEwICsrKysrKy0tLS0KIDMgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0
aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvaW5vZGUu
YyBiL2ZzL292ZXJsYXlmcy9pbm9kZS5jCmluZGV4IGZhMjAyY2YuLjExOTVhMmMgMTAwNjQ0Ci0t
LSBhL2ZzL292ZXJsYXlmcy9pbm9kZS5jCisrKyBiL2ZzL292ZXJsYXlmcy9pbm9kZS5jCkBAIC04
NCwxMiArODQsMTEgQEAgaW50IG92bF9nZXRhdHRyKGNvbnN0IHN0cnVjdCBwYXRoICpwYXRoLCBz
dHJ1Y3Qga3N0YXQgKnN0YXQsCiAJICogcGVyc2lzdGVudCBzdF9pbm8gYWNyb3NzIG1vdW50IGN5
Y2xlLgogCSAqLwogCWlmIChvdmxfc2FtZV9zYihkZW50cnktPmRfc2IpKSB7Ci0JCW92bF9wYXRo
X2xvd2VyKGRlbnRyeSwgJnJlYWxwYXRoKTsKLQotCQlpZiAoT1ZMX1RZUEVfVVBQRVIodHlwZSkg
JiYgcmVhbHBhdGguZGVudHJ5KSB7CisJCWlmIChPVkxfVFlQRV9DT1BZVVAodHlwZSkpIHsKIAkJ
CXN0cnVjdCBrc3RhdCBsb3dlcnN0YXQ7CiAJCQl1MzIgbG93ZXJtYXNrID0gU1RBVFhfSU5PIHwg
KCFpc19kaXIgPyBTVEFUWF9OTElOSyA6IDApOwogCisJCQlvdmxfcGF0aF9sb3dlcihkZW50cnks
ICZyZWFscGF0aCk7CiAJCQllcnIgPSB2ZnNfZ2V0YXR0cigmcmVhbHBhdGgsICZsb3dlcnN0YXQs
CiAJCQkJCSAgbG93ZXJtYXNrLCBmbGFncyk7CiAJCQlpZiAoZXJyKQpkaWZmIC0tZ2l0IGEvZnMv
b3ZlcmxheWZzL292ZXJsYXlmcy5oIGIvZnMvb3ZlcmxheWZzL292ZXJsYXlmcy5oCmluZGV4IGYz
ZGQ1ZjMuLmQzZjJlZTggMTAwNjQ0Ci0tLSBhL2ZzL292ZXJsYXlmcy9vdmVybGF5ZnMuaAorKysg
Yi9mcy9vdmVybGF5ZnMvb3ZlcmxheWZzLmgKQEAgLTEzLDEwICsxMywxMiBAQAogZW51bSBvdmxf
cGF0aF90eXBlIHsKIAlfX09WTF9QQVRIX1VQUEVSCT0gKDEgPDwgMCksCiAJX19PVkxfUEFUSF9N
RVJHRQk9ICgxIDw8IDEpLAorCV9fT1ZMX1BBVEhfQ09QWVVQCT0gKDEgPDwgMiksCiB9OwogCiAj
ZGVmaW5lIE9WTF9UWVBFX1VQUEVSKHR5cGUpCSgodHlwZSkgJiBfX09WTF9QQVRIX1VQUEVSKQog
I2RlZmluZSBPVkxfVFlQRV9NRVJHRSh0eXBlKQkoKHR5cGUpICYgX19PVkxfUEFUSF9NRVJHRSkK
KyNkZWZpbmUgT1ZMX1RZUEVfQ09QWVVQKHR5cGUpCSgodHlwZSkgJiBfX09WTF9QQVRIX0NPUFlV
UCkKIAogI2RlZmluZSBPVkxfWEFUVFJfUFJFRklYIFhBVFRSX1RSVVNURURfUFJFRklYICJvdmVy
bGF5LiIKICNkZWZpbmUgT1ZMX1hBVFRSX09QQVFVRSBPVkxfWEFUVFJfUFJFRklYICJvcGFxdWUi
CmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvdXRpbC5jIGIvZnMvb3ZlcmxheWZzL3V0aWwuYwpp
bmRleCA0YTdlNWM4Li5mZDRmNzhjIDEwMDY0NAotLS0gYS9mcy9vdmVybGF5ZnMvdXRpbC5jCisr
KyBiL2ZzL292ZXJsYXlmcy91dGlsLmMKQEAgLTgzLDExICs4MywxMyBAQCBlbnVtIG92bF9wYXRo
X3R5cGUgb3ZsX3BhdGhfdHlwZShzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpCiAJCXR5cGUgPSBfX09W
TF9QQVRIX1VQUEVSOwogCiAJCS8qCi0JCSAqIE5vbi1kaXIgZGVudHJ5IGNhbiBob2xkIGxvd2Vy
IGRlbnRyeSBmcm9tIHByZXZpb3VzCi0JCSAqIGxvY2F0aW9uLgorCQkgKiBOb24tZGlyIGRlbnRy
eSBjYW4gaG9sZCBsb3dlciBkZW50cnkgb2YgaXRzIGNvcHkgdXAgb3JpZ2luLgogCQkgKi8KLQkJ
aWYgKG9lLT5udW1sb3dlciAmJiBkX2lzX2RpcihkZW50cnkpKQotCQkJdHlwZSB8PSBfX09WTF9Q
QVRIX01FUkdFOworCQlpZiAob2UtPm51bWxvd2VyKSB7CisJCQl0eXBlIHw9IF9fT1ZMX1BBVEhf
Q09QWVVQOworCQkJaWYgKGRfaXNfZGlyKGRlbnRyeSkpCisJCQkJdHlwZSB8PSBfX09WTF9QQVRI
X01FUkdFOworCQl9CiAJfSBlbHNlIHsKIAkJaWYgKG9lLT5udW1sb3dlciA+IDEpCiAJCQl0eXBl
IHw9IF9fT1ZMX1BBVEhfTUVSR0U7Ci0tIAoyLjcuNAoK
--94eb2c03b810ec3cfc054ec1cbcf--
