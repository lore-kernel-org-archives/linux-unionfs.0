Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <e856e15c-013c-424a-329c-3e98bb07d8f9@huawei.com>
References: <20180301064526.17216-1-houtao1@huawei.com> <CAOQ4uxj0SAyJUAaGOvAhp_iOzo3-51ntQzeivDvoKfjDefjvVg@mail.gmail.com>
 <e856e15c-013c-424a-329c-3e98bb07d8f9@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Mar 2018 18:03:26 +0200
Message-ID: <CAOQ4uxj1oUPX5FwUb6ZhyhNsvPW_V9SAQmSiaWB5k5G-3DcauQ@mail.gmail.com>
Subject: Re: [RFC][PATCH v3] overlay: hardlink all whiteout files into a
 single one
Content-Type: text/plain; charset="UTF-8"
To: Hou Tao <houtao1@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 1, 2018 at 3:50 PM, Hou Tao <houtao1@huawei.com> wrote:
> Hi,
>
> On 2018/3/1 20:10, Amir Goldstein wrote:
>> On Thu, Mar 1, 2018 at 8:45 AM, Hou Tao <houtao1@huawei.com> wrote:
>>> Now each whiteout file will be assigned a new inode. To reduce the
>>> overhead of allocating and freeing inodes in upper fs, creating a
>>> singleton whiteout file under workdir and hardlink all whiteout files
>>> into it.
>>>
>>> The effect is obvious: under a KVM VM, the time used for removing the
>>> linux kernel source tree is reduced from 17s to 10s.
>>>
>>> Got the idea from aufs4.
>>>
>>> Signed-off-by: Hou Tao <houtao1@huawei.com>

[...]

>>> ---
>>> +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry *workdir)
>>>  {
>>>         int err;
>>>         struct dentry *whiteout;
>>>         struct inode *wdir = workdir->d_inode;
>>> +       bool create_instead;
>>>
>>>         whiteout = ovl_lookup_temp(workdir);
>>>         if (IS_ERR(whiteout))
>>>                 return whiteout;
>>>
>>> -       err = ovl_do_whiteout(wdir, whiteout);
>>> +       if (workdir == ofs->workdir && ofs->whiteout)
>>
>> That's a damn shame, because for rm -rf of a large lower tree,
>> the whiteouts from upper dir will be removed anyway, but the
>> whiteouts from index dir with nfs_export=on will stay forever
>> (or until we figure out the best way to clean them), so deduplicating
>> the whiteouts in index dir will be most beneficial.
>
> Your are right i should also cope with the whiteout under index dir and
> they are most beneficial. But there is still benefit to hardlink the whiteout files
> in workdir into a singleton whiteout, at least the overhead of allocating and freeing
> new inodes will be eliminated (~8% overhead according to a previous perf analysis).
>

As I wrote, I think there is benefit in your patch as is and index whiteout
singleton can be dealt with later.
The way I propose to solve is NOT by keeping 2 singletons, but by keeping
a single work/index dir (see more below).

>>
>> The reason I am not objecting to merge of singleton whiteout as is
>> is because the right way to implement singleton whiteout for
>> index dir would be to use the index dir as the work dir, as Miklos
>> suggested (i.e. ofs->workdir == ofs->indexdir), so there will
>> always be only one directory where whiteouts are created.
> Are you suggesting we only need to implement singleton whiteout for whiteout files
> under index dir, Or we will use the same directory for index dir and work dir when
> nfs_export=on is used, and singleton whiteout needs to cope with that situation ?
>
> I haven't read the patch set of nfs export yet, maybe I need to understand them
> before writing the V4 ?
>

Well nfs export feature is now in upstream and I don't think you need
to study it
before V4, just before the next patch if you will end up writing it.

What you need to know about whiteout index is:
ovl_indexdir_cleanup() is called on mount to examine all index entries.
an index entry can be found to be "orphan" (nevermind what that means)
in which case it is either removed (nfs_export=off) or replaced with a whiteout
(nfs_export=on).
ovl_cleanup_index() is called after an upper entry is unlikned and again
depending on nfs_export (hiding inside ovl_index_all()) either remove
an index entry or replace it with a whiteout.

nfs_export feature depends on index feature and if nfs_export is enabled,
the "work" dir is NOT used for copy up. The "index" dir is used for copy up
and "work" dir is only used for cleanups and whiteouts.

When index feature is enabled (even if nfs export is disabled),
ovl_indexdir_cleanup() will removes copy up leftovers that look like a temp
file (begin with #), so Miklos suggested that we use "index" dir instead of
"work" dir for cleanups as well and then ofs->workdir = ofs->indexdir will
point to the same dentry (the "index" directory).

If we (or you) make that change, then with index feature enabled, the singleton
whiteout will be in the index directory and the test above (workdir ==
ofs->workdir)
will be true also when called from ovl_indexdir_cleanup() and
ovl_cleanup_index(),
so everything will "just work" w.r.t. index whiteout singleton.
One think that will have to be changed is that ovl_indexdir_cleanup()
need to learn
how to cleanup non empty temp directories (removed directories that
contain whiteouts).

You may wonder why we ever need the "work" dir and not use only "index"
dir from here on even if index is disabled, but I would very much like to keep
the existence of "index" dir as an indication that index feature was enabled
on the overlay. And I don't think it will take more than a few lines of code to
maintain this duality.

Thanks,
Amir.
