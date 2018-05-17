MIME-Version: 1.0
In-Reply-To: <CAOQ4uxh-2Hitha8_01jNqO5qd=wuX8cmqsCcz5Fhr7mP8sk2NQ@mail.gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
	<1526379972-20923-2-git-send-email-amir73il@gmail.com>
	<20180515132328.GA11678@redhat.com>
	<CAOQ4uxizDzcH7rDCTGHCpjD90RwKCqcjGCSyXx6GDU7Oj_nc6Q@mail.gmail.com>
	<CAOQ4uxj5vtH2MDkhP5UP4Mc3CMgMJoYjULZcyv1jZmSJgkDpnw@mail.gmail.com>
	<CAJfpegtC=FHdHAr5WKoMpX+aBTsMQB9Ffv0NfFouuSA3M08sqQ@mail.gmail.com>
	<20180517085305.GA23785@veci.piliscsaba.redhat.com>
	<CAOQ4uxh-2Hitha8_01jNqO5qd=wuX8cmqsCcz5Fhr7mP8sk2NQ@mail.gmail.com>
Date: Thu, 17 May 2018 11:07:09 +0200
Message-ID: <CAJfpegt_JTCDbMAs9VQ3oYKmu4v19uCOptSRGMLqL23ERASbjw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] ovl: use insert_inode_locked4() to hash a newly
 created inode
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 17, 2018 at 10:58 AM, Amir Goldstein <amir73il@gmail.com> wrote:

>> ---
>> diff --git a/fs/inode.c b/fs/inode.c
>> index 13ceb98c3bd3..bb79e3f96147 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -1002,6 +1002,52 @@ void unlock_two_nondirectories(struct inode *inode1, struct inode *inode2)
>>  }
>>  EXPORT_SYMBOL(unlock_two_nondirectories);
>>
>> +struct inode *iget5_prealloc(struct inode *inode,
>> +                            struct super_block *sb, unsigned long hashval,
>
> Maybe no need to pass in @sb...

Yep.

Thanks,
Miklos
