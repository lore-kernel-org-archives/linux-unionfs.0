From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 1/4] ovl: use insert_inode_locked4() to hash a newly
 created inode
Date: Tue, 15 May 2018 16:37:43 +0300
Message-ID: <CAOQ4uxizDzcH7rDCTGHCpjD90RwKCqcjGCSyXx6GDU7Oj_nc6Q@mail.gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
 <1526379972-20923-2-git-send-email-amir73il@gmail.com> <20180515132328.GA11678@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180515132328.GA11678@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "#v4 . 16" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 15, 2018 at 4:23 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, May 15, 2018 at 01:26:09PM +0300, Amir Goldstein wrote:
>> Currently, there is a small window where ovl_obtain_alias() can
>> race with ovl_instantiate() and create two different overlay inodes
>> with the same underlying real non-dir non-hardlink inode.
>>
>> The race requires an adversary to guess the file handle of the
>> yet to be created upper inode and decode the guessed file handle
>> after ovl_creat_real(), but before ovl_instantiate().
>>
>> This patch fixes the race, by using insert_inode_locked4() to add
>> a newly created inode to icache.
>>
>> If the newly created inode apears to already exist in icache (hashed
>> by the same real upper inode), we export this error to user instead
>> of silently not hashing the new inode.
>
> So we might return an error to user saying operation failed, but still
> create file on upper. Does that sound little odd?
>

Yes, but I don't see a better solution.

> I am wondering why can't we call ovl_get_inode() in object creation
> path. That should take care of race between creation path and file
> handle decode and only one of the paths will get to instantiate and
> initialize ovl_inode and other path will wait.
>

I don't even want to think if what you wrote makes sense.
Remember that the use case we are talking about is quite imaginary.
Ensuring internal structures consistency in our code and returning
error to user is the right thing to do for imaginary use cases IMO.

Thanks,
Amir.
