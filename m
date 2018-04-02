Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180402193518.GF23306@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-27-vgoyal@redhat.com>
 <CAOQ4uxiXV-tZHU6ZKkHkZ3+bWk90AB2B7f_DcFHYGL9+mqtNpQ@mail.gmail.com> <20180402193518.GF23306@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 2 Apr 2018 23:25:11 +0300
Message-ID: <CAOQ4uxjnBX2p5pu1Dic9HmJVTmetEM5sX6P2hO=WvsfY9Fmbxw@mail.gmail.com>
Subject: Re: [PATCH v13 26/28] ovl: Re-check redirect xattr during inode initialization
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 2, 2018 at 10:35 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 30, 2018 at 11:56:42AM +0300, Amir Goldstein wrote:
>> On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > So far redirect could be placed on directories only and now it can be
>> > placed on regular files as well. Also it could be completely removed
>> > when a metacopy copy up file's data is copied up. That means if a redirect
>> > is present during ovl_lookup(), it could be gone by the time ovl_get_inode()
>> > happens.
>> >
>>
>> There is a bit of a mess in the assumptions.
>>
>> If the inode is pure upper or indexed origin, than the alleged race ends up
>> in !(inode->i_state & I_NEW) and you discard redirect anyway.
>
> Can't these also happen when I_NEW=true. I mean inode could be flushed
> out of cache. Say one cpu is doing ovl_lookup() and thread got blocked
> while other cpu did copy up of file on other cpu, removed redirect and
> inode got flushed out of cache. Now cpu1 resumes execuction, creates
> a new inode but it needs to re-check if redirect is still present or
> not?
>

Not sure. Best to drop the idea of removing REDIRECT on copy up
and be done with it.

>>
>> If the inode is non-indexed copyup, then it is a different inode on disk
>> and different struct ovl_inode in memory than the inode of the copy up
>> we are allegedly racing with (they are broken hardlinks), so there is no
>> issue.
>
> Agreed that in case of broken hardlinks this race does not exist. But
> do we really want to optimize it here?
>

Well, if you are going to cleanup REDIRECT only on I_NEW,
then no need to special case broken hardlinks.

Thanks,
Amir.
