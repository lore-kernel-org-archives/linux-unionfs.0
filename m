From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in string (2)
Date: Thu, 25 Oct 2018 18:17:25 +0300
Message-ID: <CAOQ4uxh_WLVPnLt=r5j5wm7gET=C64RKGexGVdNyJK0d0aMr5g@mail.gmail.com>
References: <0000000000003852440576ef80b2@google.com> <CACT4Y+bR+9vy5ZKDN31gmvKk5hcoNojaBuD9Dz1wswfObyt0uw@mail.gmail.com>
 <CAOQ4uxhxON4EeWqVLN68YF4v=hr5wfQk9wZEZLZLZu7B_XGuUw@mail.gmail.com>
 <20181024090959.s5y3azpsmtswjyn5@mwanda> <CAOQ4uxi84ywY4BXJ1ZYDOQHZhbYr+GjJTrkGZvBbH4XUqR0nPw@mail.gmail.com>
 <09f6038b7642f425eba162ea2239552e12da2045.camel@kernel.org> <20181025150219.GA5539@fieldses.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0000000000007e9b2e05790f1ae2"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181025150219.GA5539@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Dmitry Vyukov <dvyukov@google.com>, syzbot+376cea2b0ef340db3dd4@syzkaller.appspotmail.com, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, syzkaller-bugs@googlegroups.com, Jan Harkes <jaharkes@cs.cmu.edu>, Mark Fasheh <mark@fasheh.com>
List-Id: linux-unionfs@vger.kernel.org

--0000000000007e9b2e05790f1ae2
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 25, 2018 at 6:02 PM Bruce Fields <bfields@fieldses.org> wrote:

> > > So I guess it has fallen between the cracks.
> > > Feel free to send a patch to Jeff.
> > >
> > > Thanks,
> > > Amir.
> >
> > Actually, this should probably go to Bruce, as he mostly takes care of
> > lockd. Patch looks correct though.
>
> Yes, if you could resend I'd be happy to handle it.--b.

Attached.
Thanks,
Amir.

--0000000000007e9b2e05790f1ae2
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-lockd-fix-access-beyond-unterminated-strings-in-prin.patch"
Content-Disposition: attachment;
	filename="0001-lockd-fix-access-beyond-unterminated-strings-in-prin.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jnoqdv9q0>
X-Attachment-Id: f_jnoqdv9q0

RnJvbSA0MDAwMGY0ZGNiZDVkZDE4YTgwZWZiNmFlZjAxMGYxMTY0OTg1NTgzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBGcmksIDI4IFNlcCAyMDE4IDIwOjQxOjQ4ICswMzAwClN1YmplY3Q6IFtQQVRDSF0gbG9j
a2Q6IGZpeCBhY2Nlc3MgYmV5b25kIHVudGVybWluYXRlZCBzdHJpbmdzIGluIHByaW50cwoKcHJp
bnRrIGZvcm1hdCB1c2VkICUqcyBpbnN0ZWFkIG9mICUuKnMsIHNvIGhvc3RuYW1lX2xlbiBkb2Vz
IG5vdCBsaW1pdAp0aGUgbnVtYmVyIG9mIGJ5dGVzIGFjY2Vzc2VkIGZyb20gaG9zdG5hbWUuCgpT
aWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgotLS0KIGZz
L2xvY2tkL2hvc3QuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2xvY2tkL2hvc3QuYyBiL2ZzL2xvY2tkL2hvc3Qu
YwppbmRleCBkMzVjZDZiZTA2NzUuLjkzZmI3Y2YwYjkyYiAxMDA2NDQKLS0tIGEvZnMvbG9ja2Qv
aG9zdC5jCisrKyBiL2ZzL2xvY2tkL2hvc3QuYwpAQCAtMzQxLDcgKzM0MSw3IEBAIHN0cnVjdCBu
bG1faG9zdCAqbmxtc3ZjX2xvb2t1cF9ob3N0KGNvbnN0IHN0cnVjdCBzdmNfcnFzdCAqcnFzdHAs
CiAJfTsKIAlzdHJ1Y3QgbG9ja2RfbmV0ICpsbiA9IG5ldF9nZW5lcmljKG5ldCwgbG9ja2RfbmV0
X2lkKTsKIAotCWRwcmludGsoImxvY2tkOiAlcyhob3N0PSclKnMnLCB2ZXJzPSV1LCBwcm90bz0l
cylcbiIsIF9fZnVuY19fLAorCWRwcmludGsoImxvY2tkOiAlcyhob3N0PSclLipzJywgdmVycz0l
dSwgcHJvdG89JXMpXG4iLCBfX2Z1bmNfXywKIAkJCShpbnQpaG9zdG5hbWVfbGVuLCBob3N0bmFt
ZSwgcnFzdHAtPnJxX3ZlcnMsCiAJCQkocnFzdHAtPnJxX3Byb3QgPT0gSVBQUk9UT19VRFAgPyAi
dWRwIiA6ICJ0Y3AiKSk7CiAKLS0gCjIuMTcuMQoK
--0000000000007e9b2e05790f1ae2--
