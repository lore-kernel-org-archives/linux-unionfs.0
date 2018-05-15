Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180514203040.GA6717@redhat.com>
References: <1526116631-24186-1-git-send-email-amir73il@gmail.com>
 <1526116631-24186-2-git-send-email-amir73il@gmail.com> <20180514203040.GA6717@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 15 May 2018 08:20:21 +0300
Message-ID: <CAOQ4uxjmvgju1dA1wTj=kOhog_WozSoDCFxQttWJMph8kcJq-w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ovl: use d_instantiate_new() to instantiate a new dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 14, 2018 at 11:30 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, May 12, 2018 at 12:17:09PM +0300, Amir Goldstein wrote:
>> Currently, there is a small window where ovl_obtain_alias() can
>> race with ovl_instantiate() and create two aliases for an overlay
>> directory inode, see Al's explanation in this post:
>> https://marc.info/?l=linux-fsdevel&m=152599914515224&w=2
>>
>> This patch fixes the race, by using the d_instantiate_new() helper.
>>
>> Another logic change by this patch is that if there is an
>> inconcsistency and a new created upper inode apears to already
>> exist in icache (hashed by the same real upper inode), we will
>> export this error to user instead of silently not hashing the new
>> inode.
>>
>> Backporting only makes sense for v4.16 where NFS export was introduced.
>
> Hi Amir,
>
> So for ovlerlay, this race does not exist for directories as you fall
> back to lookup path and don't call ovl_obtain_alias(). Does that mean it
> exists for non-dir only and that's what you are trying to fix.

Hi Vivek,

Thanks for being alert.
You are right about the fact that overlay doesn't call ovl_obtain_alias()
for dir and no, this race is not relevant for non-dir, because non-dir
may have more than one hashed alias.

However, I'm afraid a race does exists with ovl_get_dentry() vs.
ovl_instantiate(). The race can end up with two different inodes
for the same directory. This is what ovl_insert_inode_locked() fixes.

I am not sure if there is also a race with inserting dentry to cache
I'll need to look closer.

>
> I would be nice to add few more lines describing exact race. It makes
> it easier and one does not have to find another email thread and
> dig out a specific email to figure out what was the race exactly and
> how does apply to overlayfs.
>

Well, I did link to the exact post with the description, although
the race Al explains about is completely different than the inode insert
race, so I'll need to revise the commit message.

Thanks,
Amir.
