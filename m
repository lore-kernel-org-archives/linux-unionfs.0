Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhQ1+TsxDnqefSEk6yoZuokUeKbLPdPyWFg94mfX1cgNQ@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-7-mszeredi@redhat.com>
 <20180604084827.GE11333@infradead.org> <CAJfpeguhXik+bEb+FWf8s=v93yaoqReAUmr1DkG1zBxEYnEfsg@mail.gmail.com>
 <CAOQ4uxjSuNxyLgzQGLqB6QYN9u+81uBvCnFy9iOJBEb+Nk4y5w@mail.gmail.com>
 <CAJfpegs=QAc=gQ5NnJpgHB+jn_USXy9rHKhWMpY5XRaFC6Lh+A@mail.gmail.com> <CAOQ4uxhQ1+TsxDnqefSEk6yoZuokUeKbLPdPyWFg94mfX1cgNQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Jul 2018 10:18:46 +0300
Message-ID: <CAOQ4uxiqYzqouyw9=MTHkw-VT+ERUYdMSX4wga-EeVBrd7SZmw@mail.gmail.com>
Subject: Re: [PATCH 06/39] vfs: add f_op->pre_mmap()
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Jun 27, 2018 at 3:07 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jun 6, 2018 at 10:47 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Jun 6, 2018 at 8:52 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Tue, Jun 5, 2018 at 2:36 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Mon, Jun 4, 2018 at 10:48 AM, Christoph Hellwig <hch@infradead.org> wrote:
>>>>> On Tue, May 29, 2018 at 04:43:06PM +0200, Miklos Szeredi wrote:
>>>>>> This is needed by overlayfs to be able to copy up a file from a read-only
>>>>>> lower layer to a writable layer when being mapped shared.  When copying up,
>>>>>> overlayfs takes VFS locks that would violate locking order when nested
>>>>>> inside mmap_sem.
>>>>>>
>>>>>> Add a new f_op->pre_mmap method, which is called before taking mmap_sem.
>>>>>
>>>>> NAK.  We really should not add multiple methods for mmap, and everytime
>>>>> this came up we found a better way to solve the problem instead.  Most
>>>>> recent example was the socket zero copy receive code.
>>>>
>>>> Okay, I'll drop this.
>>>
>>> Need to remove copy_up_shared from overlayfs.txt.
>>
>> Right.  If the pull goes trough in this cycle, I'll send a followup
>> patch to fix that.
>>
>
> Reminder: stale doc is still in current overlayfs-next.
>

Still there.

Thanks,
Amir.
