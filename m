From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: copy new uid/gid into overlayfs runtime inode
Date: Fri, 4 Mar 2016 06:06:17 +0100
Message-ID: <CAJfpegvco8fueQrV=ysFrBpzc-C7t-W36gayZZdD+_2YtCYe2w@mail.gmail.com>
References: <145424648900.10573.4331586687947621230.stgit@zurg>
	<CAJfpegvssUL0cq+PFzh69mTVVs7CJnqBWsRg+Oxo+Tzx5Gf1Vw@mail.gmail.com>
	<CA+icZUXuOnsq0XU+QvkFw4SEX=AJmLME6hVOQ7sxz64GMHKthQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+icZUXuOnsq0XU+QvkFw4SEX=AJmLME6hVOQ7sxz64GMHKthQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Mar 3, 2016 at 7:58 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On 3/3/16, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Sun, Jan 31, 2016 at 2:21 PM, Konstantin Khlebnikov <koct9i@gmail.com>
>> wrote:
>>> Overlayfs must update uid/gid after chown, otherwise functions
>>> like inode_owner_or_capable() will check user against stale uid.
>>> Catched by xfstests generic/087, it chowns file and calls utimes.
>>
>> Queued up patch.  Thanks.
>>
>
> In which Git tree you do that?
> [1] points to [2], still true?

It is.  I just forgot to push yesterday evening.  Pushed now.

Thanks,
Miklos


>
> - Sedat -
>
> [1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS#n8110
> [2] http://git.kernel.org/cgit/linux/kernel/git/mszeredi/vfs.git/
>
