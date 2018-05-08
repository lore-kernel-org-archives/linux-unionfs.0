From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 15/35] ovl: add ovl_fsync()
Date: Tue, 8 May 2018 18:02:31 +0300
Message-ID: <CAOQ4uxjyXLW3xHOtpjz0EnFGWk-TzEHTh5mdzH+jBbXDLpSRtQ@mail.gmail.com>
References: <20180507083807.28792-1-mszeredi@redhat.com> <20180507083807.28792-16-mszeredi@redhat.com>
 <CAOQ4uxhFzFFpF+ghACKTzzU_UrrJ3_+U6LwCOVXhgUyGe6=fVQ@mail.gmail.com> <CAJfpegvV8r8Bp6c2gZYhX1pOqDGHPDmURB6+x=09uR1diERUSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegvV8r8Bp6c2gZYhX1pOqDGHPDmURB6+x=09uR1diERUSg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 8, 2018 at 5:57 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, May 8, 2018 at 7:14 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Mon, May 7, 2018 at 11:37 AM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>>> Implement stacked fsync().
>>>
>>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>>> ---
>>>  fs/overlayfs/file.c | 20 ++++++++++++++++++++
>>>  1 file changed, 20 insertions(+)
>>>
>>> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
>>> index a7af56861aa5..419aa3f9967b 100644
>>> --- a/fs/overlayfs/file.c
>>> +++ b/fs/overlayfs/file.c
>>> @@ -233,10 +233,30 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>>>         return ret;
>>>  }
>>>
>>> +static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>>> +{
>>> +       struct fd real;
>>> +       const struct cred *old_cred;
>>> +       int ret;
>>> +
>>
>> Don't sync non-upper. same as ovl_dir_fsync()
>
> Ah, that was about EROFS returned by lower fsync, right?
>

Yap. to reason to try and sync a lower file.

Thanks,
Amir.
