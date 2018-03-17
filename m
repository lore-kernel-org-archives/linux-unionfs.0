Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegvBEXgi=P8Sciv+U6VqcjsLJChR1OdwZyZA_PoL3MNTNA@mail.gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com> <CAJfpegvBEXgi=P8Sciv+U6VqcjsLJChR1OdwZyZA_PoL3MNTNA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 17 Mar 2018 10:29:12 +0200
Message-ID: <CAOQ4uxiGQqGQy_te6PU7h1C_i1-JMEvfsG5B63GmLJDGrhNYLA@mail.gmail.com>
Subject: Re: [PATCH v8 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Eddie Horng <eddiehorng.tw@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Nov 8, 2017 at 12:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Nov 7, 2017 at 5:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
[...]

> The -oxino patches are interesting, but maybe we should leave them
> brewing for another cycle.  Do you agree?
>

Miklos,

FYI, I pushed ovl-xino branch that is rebased on v4.16-rc5 and on top
of a few fixes in branch ovl-fixes:
* 5668064a61f6 - ovl: set i_ino to the value of st_ino for NFS export
* 579515ad5c75 - ovl: opaque xattr should overrule redirect xattr
* 0161362aeab7 - ovl: fix lookup with middle layer opaque dir and
absolute path redirects

Vivek has already written an xfstest for the middle layer opaque issue.
Eddie has already tested the NFSv3 DT_UNKNOWN issue as
well as the ovl-xino branch that fixes NFSv3 DT_UNKNOWN for the non samefs case.

You may want to pick at least the first and third patches from
ovl-fixes to v4.16.

Thanks,
Amir.
