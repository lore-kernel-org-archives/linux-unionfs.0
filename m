From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Fri, 11 Nov 2016 18:17:07 +0200
Message-ID: <CAOQ4uxgU3Pv_SRJhfOGVevuGop=fQ=rPK01UO0ccgy1yEM_hJA@mail.gmail.com>
References: <1478817883-27662-5-git-send-email-amir73il@gmail.com>
 <20161110230221.GL19539@ZenIV.linux.org.uk> <20161110230557.GM19539@ZenIV.linux.org.uk>
 <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
 <20161110231757.GN19539@ZenIV.linux.org.uk> <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
 <20161110235444.GO19539@ZenIV.linux.org.uk> <CAOQ4uxiR6wsk97jQ43hu=hkJ1JQRaerSSEwjVr8tX6ia-yfOgA@mail.gmail.com>
 <20161111002756.GP19539@ZenIV.linux.org.uk> <CAOQ4uxibJf7BVSOeRdfcE7VtU2rkrii=Pu9OL0uZPavpudODeQ@mail.gmail.com>
 <20161111154034.GR19539@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38605 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756058AbcKKQRK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Nov 2016 11:17:10 -0500
In-Reply-To: <20161111154034.GR19539@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Nov 11, 2016 at 5:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Nov 11, 2016 at 04:43:57PM +0200, Amir Goldstein wrote:
>
>> > Surely, the copying of data itself is outside of that lock, isn't it?
>>
>> Mmmmmm, no it isn't, but I am going to make it right.
>
> Well, if you really have the copyup itself done under lock_rename(), you
> are looking at potentially copying gigabytes of data from r/o layer to
> workdir under fs-wide lock.  _That_ is really asking for contention from
> hell, and for no good reason.  Renames/whiteout creations/removals are
> trivial noise compared to that.  I'm somewhat surprised, TBH - I thought
> the copyup itself is done outside of that thing.  Are you sure it really
> isn't?

I'm afraid so.
It seems to me that most of the time, lock_rename() is being used in
overlayfs for no better alternative to lock 2 directories (work+upper).

My suggestion is a small modification to the overlayfs locking scheme.
---Instead of this:
assert(lock_rename(workdir, upperdir) != NULL));
   copy_up(src, tmp);
   vfs_rename(tmp, dst);
unlock_rename(workdir, upperdir);

+++Use this:
assert(lock_rename(workdir, upperdir) != NULL));
mutex_unlock(s_vfs_rename_mutex);
   copy_up(src, tmp);
inode_unlock(upperdir);
inode_unlock(workdir);
assert(lock_rename(workdir, upperdir) != NULL));
  vfs_rename(tmp, dst);
unlock_rename(workdir, upperdir);

Miklos,

Do you see any problem with the proposed scheme?
Anything that can go wrong while releasing the workdir lock before vfs_rename()?

Do you think we should do the same for the remove/create functions
or leave the lock_rename() over whiteout+rename+cleanup as it is?

Amir.
