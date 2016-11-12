From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Sat, 12 Nov 2016 21:45:17 +0200
Message-ID: <CAOQ4uxgV5iBczUdH_VLu8KC_SkBU0ibqf8o=8+iHbdc5gACAGA@mail.gmail.com>
References: <20161110230557.GM19539@ZenIV.linux.org.uk> <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
 <20161110231757.GN19539@ZenIV.linux.org.uk> <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
 <20161110235444.GO19539@ZenIV.linux.org.uk> <CAOQ4uxiR6wsk97jQ43hu=hkJ1JQRaerSSEwjVr8tX6ia-yfOgA@mail.gmail.com>
 <20161111002756.GP19539@ZenIV.linux.org.uk> <CAOQ4uxibJf7BVSOeRdfcE7VtU2rkrii=Pu9OL0uZPavpudODeQ@mail.gmail.com>
 <20161111154034.GR19539@ZenIV.linux.org.uk> <CAOQ4uxgU3Pv_SRJhfOGVevuGop=fQ=rPK01UO0ccgy1yEM_hJA@mail.gmail.com>
 <20161111172737.GS19539@ZenIV.linux.org.uk> <CAOQ4uxgnuj8i_AO-aPFswjH2+8T-q=q5Q98Rsn2pkfz0u2rUNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxgnuj8i_AO-aPFswjH2+8T-q=q5Q98Rsn2pkfz0u2rUNQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 11, 2016 at 8:07 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Nov 11, 2016 at 7:27 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Fri, Nov 11, 2016 at 06:17:07PM +0200, Amir Goldstein wrote:
>>
>>> I'm afraid so.
>>> It seems to me that most of the time, lock_rename() is being used in
>>> overlayfs for no better alternative to lock 2 directories (work+upper).
>>>
>> Huh???
>>
>> ->rename() definitely counts upon parents being locked; please, read the
>> damn Documentation/filesystems/locking, it's there for a reason.
>>
>
> I know it does. lock_rename() before vfs_rename() re-aquires the parent locks.
> The reason I am unlocking them is to be able to re-take s_vfs_rename_mutex
> and 2 parent dirs in correct order.
>
>> The real question is why the fsck do you need to lock the workdir for the
>> duration of copying at all.  O_TMPFILE open + writes there doesn't need
>> lock_rename() *or* parents being locked.  You need the parent locked when
>> you link the sucker in place, but that's it.  IDGI...
>
> I am starting to understand the reasons of how the current locking scheme for
> copy up became to be what it is.
>
> It stems from the fact the the parent upper dir is used as the synchronization
> object to avoid double copy up (and my suggested scheme does not preserve
> that). Then workdir needs to be locked before we link the temp file.
> And then we cannot lock upperdir->workdir in that order without holding
> s_vfs_rename_mutex while we do that, so the whole locking became
> lock_rename() over the whole thing.
>
> I can see the following solution:
>
> For regular file copy up, don't use workdir at all, use O_TMPFILE instead
> then only need to take upperdir lock and it can be the synchronization
> object for the entire copy-up, which also allows for concurrent copy up
> to different directories.
>
> For non-regular file copy up, use workdir as it is used now and take
> lock_rename() for the entire copy up as it is now.
>
> If upper fs does not support O_TMPFILE, we can resort to the
> contending copy-up.
>
> I am working on a RFC patch. Will send it out over weekend.
> Bare with me guys, I'll get it right eventually...
>

I posted the new patches. They are much simpler than my previous attempt.
I did not go for the O_TMPFILE solution because I found a solution
that IMO is simple and clean without changing too much code.

In a nut shell, the overlay inode is used to synchronize copy up
regular files (outside the existing locks), so lock_rename can be dropped
for the period of copying data and re-acquired before the final rename.

Amir.
