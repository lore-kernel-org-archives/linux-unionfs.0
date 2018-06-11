From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 23/39] ovl: add O_DIRECT support
Date: Mon, 11 Jun 2018 10:08:30 +0200
Message-ID: <CAJfpegteZatDXOV+6FQKOE9pOA=_FErGRn1Jj1fHUYm_QLb4ew@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-24-mszeredi@redhat.com>
 <20180610053128.GO30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180610053128.GO30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jun 10, 2018 at 7:31 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, May 29, 2018 at 04:43:23PM +0200, Miklos Szeredi wrote:
>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>> ---
>>  fs/overlayfs/file.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
>> index 3f610a5b38e4..e5e7ccaaf9ec 100644
>> --- a/fs/overlayfs/file.c
>> +++ b/fs/overlayfs/file.c
>> @@ -110,6 +110,9 @@ static int ovl_open(struct inode *inode, struct file *file)
>>       if (IS_ERR(realfile))
>>               return PTR_ERR(realfile);
>>
>> +     /* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
>> +     file->f_mapping = realfile->f_mapping;
>
> Umm...  What happens if upper layer doesn't allow O_DIRECT, while the lower one does?

Will get EINVAL on read(2) after copy up.  Not sure if it can be
called a regression, since it's a corner case of a corner case.

I think proper solution is to support O_DIRECT unconditionally on
upper (and for the likes of shmfs, just fall back to "cached" I/O).

Thanks,
Miklos
