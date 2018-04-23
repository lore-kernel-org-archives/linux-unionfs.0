From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH 13/35] ovl: readd fsync
Date: Mon, 23 Apr 2018 15:39:45 +0200
Message-ID: <CAJfpegsmxOtn9yjy4fvsYOt7cL49mzOM00bh8+CgxJcT3meLBQ@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <20180412150826.20988-14-mszeredi@redhat.com>
 <20180423133617.GB2794@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180423133617.GB2794@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Apr 23, 2018 at 3:36 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Apr 12, 2018 at 05:08:04PM +0200, Miklos Szeredi wrote:
>> Implement stacked fsync().
>>
>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>> ---
>>  fs/overlayfs/file.c | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
>> index b98204c1c19c..4417527667ff 100644
>> --- a/fs/overlayfs/file.c
>> +++ b/fs/overlayfs/file.c
>> @@ -222,10 +222,30 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>>       return ret;
>>  }
>>
>> +static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>> +{
>> +     struct fd real;
>> +     const struct cred *old_cred;
>> +     int ret;
>> +
>> +     ret = ovl_real_file(file, &real);
>> +     if (ret)
>> +             return ret;
>> +
>> +     old_cred = ovl_override_creds(file_inode(file)->i_sb);
>> +     ret = vfs_fsync_range(real.file, start, end, datasync);
>> +     revert_creds(old_cred);
>
> Can we avoid calling fsync() on real file if it is not upper. Is it worth
> optimizing.

Not sure it's worth bothering with.   If caller of fsync(2) didn't
worry about cost, then why should we?

Thanks,
Miklos
