From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Fri, 11 Nov 2016 18:44:01 +0100
Message-ID: <CAJfpeguTOvO9P+khKxOX_-SBjePzeLqUqQ2B9sBszjamD3wWvA@mail.gmail.com>
References: <20161110230557.GM19539@ZenIV.linux.org.uk> <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
 <20161110231757.GN19539@ZenIV.linux.org.uk> <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
 <20161110235444.GO19539@ZenIV.linux.org.uk> <CAOQ4uxiR6wsk97jQ43hu=hkJ1JQRaerSSEwjVr8tX6ia-yfOgA@mail.gmail.com>
 <20161111002756.GP19539@ZenIV.linux.org.uk> <CAOQ4uxibJf7BVSOeRdfcE7VtU2rkrii=Pu9OL0uZPavpudODeQ@mail.gmail.com>
 <20161111154034.GR19539@ZenIV.linux.org.uk> <CAOQ4uxgU3Pv_SRJhfOGVevuGop=fQ=rPK01UO0ccgy1yEM_hJA@mail.gmail.com>
 <20161111172737.GS19539@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20161111172737.GS19539@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>, Konstantin Khlebnikov <koct9i@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 11, 2016 at 6:27 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Nov 11, 2016 at 06:17:07PM +0200, Amir Goldstein wrote:
>
>> I'm afraid so.
>> It seems to me that most of the time, lock_rename() is being used in
>> overlayfs for no better alternative to lock 2 directories (work+upper).
>>
>> My suggestion is a small modification to the overlayfs locking scheme.
>> ---Instead of this:
>> assert(lock_rename(workdir, upperdir) != NULL));
>>    copy_up(src, tmp);
>>    vfs_rename(tmp, dst);
>> unlock_rename(workdir, upperdir);
>>
>> +++Use this:
>> assert(lock_rename(workdir, upperdir) != NULL));
>> mutex_unlock(s_vfs_rename_mutex);
>>    copy_up(src, tmp);
>> inode_unlock(upperdir);
>> inode_unlock(workdir);
>> assert(lock_rename(workdir, upperdir) != NULL));
>>   vfs_rename(tmp, dst);
>> unlock_rename(workdir, upperdir);
>>
>> Miklos,
>>
>> Do you see any problem with the proposed scheme?
>> Anything that can go wrong while releasing the workdir lock before vfs_rename()?
>
> Huh???
>
> ->rename() definitely counts upon parents being locked; please, read the
> damn Documentation/filesystems/locking, it's there for a reason.
>
> The real question is why the fsck do you need to lock the workdir for the
> duration of copying at all.  O_TMPFILE open + writes there doesn't need
> lock_rename() *or* parents being locked.  You need the parent locked when
> you link the sucker in place, but that's it.  IDGI...

There's that.  The other thing that lock_rename does is prevent
multiple copy ups on the same file.   Arguably it's an overkill, but a
replacement needs to be added.

Fact is, nobody ever reported this blatant performance bottleneck.
Probably because copying up gigabyte files is not the usual use case
for union filesystems...

Thanks,
Miklos
