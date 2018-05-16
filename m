From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 1/4] ovl: use insert_inode_locked4() to hash a newly
 created inode
Date: Wed, 16 May 2018 12:51:34 +0300
Message-ID: <CAOQ4uxgjO=J-LtcrjtiE1cQDoV-3P1b=6+ixVQMBKnUm7WV+tQ@mail.gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
 <1526379972-20923-2-git-send-email-amir73il@gmail.com> <20180515132328.GA11678@redhat.com>
 <CAOQ4uxizDzcH7rDCTGHCpjD90RwKCqcjGCSyXx6GDU7Oj_nc6Q@mail.gmail.com> <CAJfpegtMvjEjC7B4JpnjyYxzbY=pbW_ATKkKCkjKEsQqzxqqNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAJfpegtMvjEjC7B4JpnjyYxzbY=pbW_ATKkKCkjKEsQqzxqqNg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "#v4 . 16" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, May 16, 2018 at 11:34 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, May 15, 2018 at 3:37 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Tue, May 15, 2018 at 4:23 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> On Tue, May 15, 2018 at 01:26:09PM +0300, Amir Goldstein wrote:
>>>> Currently, there is a small window where ovl_obtain_alias() can
>>>> race with ovl_instantiate() and create two different overlay inodes
>>>> with the same underlying real non-dir non-hardlink inode.
>>>>
>>>> The race requires an adversary to guess the file handle of the
>>>> yet to be created upper inode and decode the guessed file handle
>>>> after ovl_creat_real(), but before ovl_instantiate().
>>>>
>>>> This patch fixes the race, by using insert_inode_locked4() to add
>>>> a newly created inode to icache.
>>>>
>>>> If the newly created inode apears to already exist in icache (hashed
>>>> by the same real upper inode), we export this error to user instead
>>>> of silently not hashing the new inode.
>>>
>>> So we might return an error to user saying operation failed, but still
>>> create file on upper. Does that sound little odd?
>>>
>>
>> Yes, but I don't see a better solution.
>
> Might be better to kick the other, offending inode out, instead of
> returning an error.  It would also simplify the error handling.
>
> We can do that by creating an ovl_inode_test_kick() variant that
> unhashes the inode on match.  Also needs insert_inode_locked4() to use
> hlist_for_each_entry_safe() instead of hlist_for_each_entry().
>

Do you really think that this corner use case calls for such actions,
as creating flavors of inode cache helpers?
Remember that the so called "offending" inode, is not offending in
a way that is wrong or incomplete in any way.

So worst worst worst case this is a very temporal error.

Thanks,
Amir.
