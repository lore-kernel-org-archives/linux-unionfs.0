MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj5dLOT3U5feWRmbh-BO8Qup9S3Cr9t_2oD5AKAHsLYxg@mail.gmail.com>
References: <20180918133434.27437-1-amir73il@gmail.com>
	<CAOQ4uxj5dLOT3U5feWRmbh-BO8Qup9S3Cr9t_2oD5AKAHsLYxg@mail.gmail.com>
Date: Mon, 24 Sep 2018 10:56:32 +0200
Message-ID: <CAJfpegvkb8fk-a6+9j2Hf+oSkKOxAFF7NOLNZomUP+D4YYcjWg@mail.gmail.com>
Subject: Re: [PATCH 0/4] Assorted overlayfs fixes for 4.19-rc5
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Sep 24, 2018 at 10:25 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Sep 18, 2018 at 4:34 PM Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> Miklos,
>>
>> Found one memory leak that needs a fix for stable and
>> two missing freeze protections in stacked f_ops.
>>
>> Last patch is not a bugfix, but it fixes a trap that we set
>> for developers back in v4.10 - and you happened to step into.
>>
>> The series passed xfstests -g quick with overlayfs over
>> xfs and ext4 and the usual unionmount testsuite torture.
>>
>> The memory leak was detected with tests overlay/051,053
>> after I enabled kmemleak on my test setup.
>>
>
> Miklos,
>
> Maybe not enough time has passed to justify a PING, but you know I get
> edgy towards the end of a release cycle, especially a weird release cycle as
> this one...

Thanks for the reminder.   Pushed to overlayfs-next and will ask Greg
to pull before -rc6.  If I forget, please remind again ;)

Thanks,
Miklos
