Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegu6knx6oZ7-GKpeG0AtOT3MgtT_F+QBY7EeHj1cg-hb6g@mail.gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
 <CAJfpegvBEXgi=P8Sciv+U6VqcjsLJChR1OdwZyZA_PoL3MNTNA@mail.gmail.com>
 <CAOQ4uxiGQqGQy_te6PU7h1C_i1-JMEvfsG5B63GmLJDGrhNYLA@mail.gmail.com> <CAJfpegu6knx6oZ7-GKpeG0AtOT3MgtT_F+QBY7EeHj1cg-hb6g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 22 Mar 2018 17:07:02 +0200
Message-ID: <CAOQ4uxg65nMyqAcyT5dW7A2ef9PDx1MKzFO-W2nV=XoT+=m0Ew@mail.gmail.com>
Subject: Re: [PATCH v8 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Eddie Horng <eddiehorng.tw@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 22, 2018 at 4:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Sat, Mar 17, 2018 at 9:29 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Wed, Nov 8, 2017 at 12:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Tue, Nov 7, 2017 at 5:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> [...]
>>
>>> The -oxino patches are interesting, but maybe we should leave them
>>> brewing for another cycle.  Do you agree?
>>>
>>
>> Miklos,
>>
>> FYI, I pushed ovl-xino branch that is rebased on v4.16-rc5 and on top
>> of a few fixes in branch ovl-fixes:
>> * 5668064a61f6 - ovl: set i_ino to the value of st_ino for NFS export
>> * 579515ad5c75 - ovl: opaque xattr should overrule redirect xattr
>> * 0161362aeab7 - ovl: fix lookup with middle layer opaque dir and
>> absolute path redirects
>
> I'm a bit confused about this last one.  It's in Vivek's lookup fixes
> series as well but in a slightly different form.  Which one should I
> be looking at?
>

Vivek's patch is the later version (so v2).
There are 2 differences between v1 and v2:
1. Vivek's commit message is more elaborate, so should take it.
2. Vivek's patch sets only d->stop and not d->opaque
This difference is purely semantic, because d->opaque is
ignored in ovl_lookup() for anything but the upper layer.

I am fine with the semantic change, but wasn't sure if you
had other meaning in mind w.r.t d->opaque and metadata
going forward.

Thanks,
Amir.
