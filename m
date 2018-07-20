MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiqYzqouyw9=MTHkw-VT+ERUYdMSX4wga-EeVBrd7SZmw@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
	<20180529144339.16538-7-mszeredi@redhat.com>
	<20180604084827.GE11333@infradead.org>
	<CAJfpeguhXik+bEb+FWf8s=v93yaoqReAUmr1DkG1zBxEYnEfsg@mail.gmail.com>
	<CAOQ4uxjSuNxyLgzQGLqB6QYN9u+81uBvCnFy9iOJBEb+Nk4y5w@mail.gmail.com>
	<CAJfpegs=QAc=gQ5NnJpgHB+jn_USXy9rHKhWMpY5XRaFC6Lh+A@mail.gmail.com>
	<CAOQ4uxhQ1+TsxDnqefSEk6yoZuokUeKbLPdPyWFg94mfX1cgNQ@mail.gmail.com>
	<CAOQ4uxiqYzqouyw9=MTHkw-VT+ERUYdMSX4wga-EeVBrd7SZmw@mail.gmail.com>
Date: Fri, 20 Jul 2018 10:04:57 +0200
Message-ID: <CAJfpegu5YAHqEe-wod77LTUcx_fFQbWu9uW9mSxkRMK2P-x-jg@mail.gmail.com>
Subject: Re: [PATCH 06/39] vfs: add f_op->pre_mmap()
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jul 20, 2018 at 9:18 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jun 27, 2018 at 3:07 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Wed, Jun 6, 2018 at 10:47 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Wed, Jun 6, 2018 at 8:52 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>
>>>> Need to remove copy_up_shared from overlayfs.txt.
>>>
>>> Right.  If the pull goes trough in this cycle, I'll send a followup
>>> patch to fix that.
>>>
>>
>> Reminder: stale doc is still in current overlayfs-next.
>>
>
> Still there.

Fixed.

Thanks,
Miklos
