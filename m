Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxizDzcH7rDCTGHCpjD90RwKCqcjGCSyXx6GDU7Oj_nc6Q@mail.gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
 <1526379972-20923-2-git-send-email-amir73il@gmail.com> <20180515132328.GA11678@redhat.com>
 <CAOQ4uxizDzcH7rDCTGHCpjD90RwKCqcjGCSyXx6GDU7Oj_nc6Q@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 17 May 2018 09:03:54 +0300
Message-ID: <CAOQ4uxj5vtH2MDkhP5UP4Mc3CMgMJoYjULZcyv1jZmSJgkDpnw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] ovl: use insert_inode_locked4() to hash a newly
 created inode
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 15, 2018 at 4:37 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, May 15, 2018 at 4:23 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Tue, May 15, 2018 at 01:26:09PM +0300, Amir Goldstein wrote:
>>> Currently, there is a small window where ovl_obtain_alias() can
>>> race with ovl_instantiate() and create two different overlay inodes
>>> with the same underlying real non-dir non-hardlink inode.
>>>
>>> The race requires an adversary to guess the file handle of the
>>> yet to be created upper inode and decode the guessed file handle
>>> after ovl_creat_real(), but before ovl_instantiate().
>>>
>>> This patch fixes the race, by using insert_inode_locked4() to add
>>> a newly created inode to icache.
>>>
>>> If the newly created inode apears to already exist in icache (hashed
>>> by the same real upper inode), we export this error to user instead
>>> of silently not hashing the new inode.
>>
>> So we might return an error to user saying operation failed, but still
>> create file on upper. Does that sound little odd?
>>
>
> Yes, but I don't see a better solution.
>
>> I am wondering why can't we call ovl_get_inode() in object creation
>> path. That should take care of race between creation path and file
>> handle decode and only one of the paths will get to instantiate and
>> initialize ovl_inode and other path will wait.
>>
>
> I don't even want to think if what you wrote makes sense.
> Remember that the use case we are talking about is quite imaginary.
> Ensuring internal structures consistency in our code and returning
> error to user is the right thing to do for imaginary use cases IMO.
>

Having being forced to think about it ;-), I think using ovl_get_inode()
in create code does make a weird sort of sense.

The reason it is weird is because we will always be throwing away
the new inode that we allocated in ovl_create_object().
AFAICS, if only reason we need to allocate new inode in
ovl_create_object() is to calculate i_mode with inode_init_owner()
and that calculation can be factored out to not need an inode.

The reason it does makes sense to use ovl_get_inode(), is because
the alternative that Miklos suggested is to insert the new inode on
the very very likely use case and throw away the new inode in the
very very unlikely use case of collision. That alternative creates a
somewhat complicated code path that is rarely to never executed -
not the best practice.

Thanks,
Amir.
