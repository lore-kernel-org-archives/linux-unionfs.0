Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uximhvDrOn6s-5X-BeGvfG0RtTBU-WA6fEjfyYEkn4jvNw@mail.gmail.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-10-vgoyal@redhat.com>
 <CAOQ4uxg5xDZJVuys69QtGBRGcs3=zfkJQoZgTZRp+cG+GGVzEQ@mail.gmail.com>
 <20180430140243.GB7960@redhat.com> <CAOQ4uximhvDrOn6s-5X-BeGvfG0RtTBU-WA6fEjfyYEkn4jvNw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 1 May 2018 17:37:09 +0300
Message-ID: <CAOQ4uxg5zDffN8VneWQCTd4N+trCCx0v7=paL9_hdMZj5CidYA@mail.gmail.com>
Subject: Re: [PATCH v14 09/31] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 30, 2018 at 9:08 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Apr 30, 2018 at 5:02 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
[...]
>>
>> I think we need to check metacopy here otherwise it becomes racy. For
>> example, what if there is a hard link (say, l1 and l2) with metacopy xattr.
>> ovl_lookup(l1) will think metacopy is on while another thread on another
>> cpu might have trigged copy up, remove metacopy xattr. And it is possible
>> that inode got flushed out of cache. So by the time ovl_lookup(l1), calls
>> iget5_locked(), it will get a new inode and it will initialize inode
>> with wrong information.
>>
>> I had done similar thing for REDIRECT, but once we removed logic to
>> remove REDIRECT on copy up, I felt I did not have to check redirect
>> again here.
>>
>> In general, I feel that once we have the inode lock, we should check
>> metacopy and redirect both and then initialize inode. And not rely
>> on information which was checked outside the lock and might have
>> been stale by now.
>>
>
> Hmmm... so as you once already said, we have a race with INDEX as well.
> In general, I feel it would be better to do a minimal sanity check inside
> inode lock for INDEX and METACOPY (maybe REDIRECT) and make
> sure they are consistent with the info in ovl_inode_info.
> If they are not, return -ESTALE and that may result in re-calling
> lookup.
>

After thinking about it some more, I believe the way we should do it
is implement ovl_iget_locked() and call it from ovl_lookup() *before*
we lookup index.

Then, *after* looking up index,
If this turns out to be a broken hardlink, we throw away the
inode that we got by lower and get a new inode hashed by upper.

Then we can initialize the inode with another helper
or directly in ovl_lookup() and unlock_new_inode().

w.r.t METACOPY things will get complicated if we remove
METACOPY xattr and the upper does not have ORIGIN.
In that case we may have an inode that is already hashed by lower,
but for a new lookup that does not see METACOPY xattr it
looks up the inode in cache by upper and this is not good.

There is one solution that you will surely not like -
instead of removing METACOPY xattr set METACOPY=n.
That means we still need to lookup lower layers for origin inode,
but we do set UPPERDATA flag.

There may be other solutions to the problem, but I cannot think
of any right now.

Thanks,
Amir.
