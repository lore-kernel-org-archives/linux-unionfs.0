MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiGQqGQy_te6PU7h1C_i1-JMEvfsG5B63GmLJDGrhNYLA@mail.gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
	<CAJfpegvBEXgi=P8Sciv+U6VqcjsLJChR1OdwZyZA_PoL3MNTNA@mail.gmail.com>
	<CAOQ4uxiGQqGQy_te6PU7h1C_i1-JMEvfsG5B63GmLJDGrhNYLA@mail.gmail.com>
Date: Thu, 22 Mar 2018 15:19:56 +0100
Message-ID: <CAJfpegu6knx6oZ7-GKpeG0AtOT3MgtT_F+QBY7EeHj1cg-hb6g@mail.gmail.com>
Subject: Re: [PATCH v8 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Eddie Horng <eddiehorng.tw@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Mar 17, 2018 at 9:29 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Nov 8, 2017 at 12:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Tue, Nov 7, 2017 at 5:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> [...]
>
>> The -oxino patches are interesting, but maybe we should leave them
>> brewing for another cycle.  Do you agree?
>>
>
> Miklos,
>
> FYI, I pushed ovl-xino branch that is rebased on v4.16-rc5 and on top
> of a few fixes in branch ovl-fixes:
> * 5668064a61f6 - ovl: set i_ino to the value of st_ino for NFS export
> * 579515ad5c75 - ovl: opaque xattr should overrule redirect xattr
> * 0161362aeab7 - ovl: fix lookup with middle layer opaque dir and
> absolute path redirects

I'm a bit confused about this last one.  It's in Vivek's lookup fixes
series as well but in a slightly different form.  Which one should I
be looking at?

Thanks,
Miklois
