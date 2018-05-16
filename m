From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 1/4] ovl: use insert_inode_locked4() to hash a newly
 created inode
Date: Wed, 16 May 2018 10:34:00 +0200
Message-ID: <CAJfpegtMvjEjC7B4JpnjyYxzbY=pbW_ATKkKCkjKEsQqzxqqNg@mail.gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
 <1526379972-20923-2-git-send-email-amir73il@gmail.com> <20180515132328.GA11678@redhat.com>
 <CAOQ4uxizDzcH7rDCTGHCpjD90RwKCqcjGCSyXx6GDU7Oj_nc6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxizDzcH7rDCTGHCpjD90RwKCqcjGCSyXx6GDU7Oj_nc6Q@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "#v4 . 16" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 15, 2018 at 3:37 PM, Amir Goldstein <amir73il@gmail.com> wrote:
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

Might be better to kick the other, offending inode out, instead of
returning an error.  It would also simplify the error handling.

We can do that by creating an ovl_inode_test_kick() variant that
unhashes the inode on match.  Also needs insert_inode_locked4() to use
hlist_for_each_entry_safe() instead of hlist_for_each_entry().

Thanks,
Miklos
