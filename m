MIME-Version: 1.0
In-Reply-To: <CAJfpegtizFNe3tm7reYMYGBsmD-dzZTHNsSGrb5BZ_gaeu2Sfw@mail.gmail.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
	<20180507174102.24086-11-vgoyal@redhat.com>
	<CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com>
	<CAJfpegtizFNe3tm7reYMYGBsmD-dzZTHNsSGrb5BZ_gaeu2Sfw@mail.gmail.com>
Date: Thu, 10 May 2018 11:52:43 +0200
Message-ID: <CAJfpegvwpPmboKaBJKYsoMkArbf0MmP-Do1UUNwVgA5SfgSe0Q@mail.gmail.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 10, 2018 at 11:36 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, May 10, 2018 at 11:19 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, May 7, 2018 at 7:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>>
>>> +               if (d.metacopy)
>>> +                       metacopy = true;
>>> +               /*
>>> +                * Do not store intermediate metacopy dentries in chain,
>>> +                * except top most lower metacopy dentry
>>
>> I don't get it.  We need the bottom most metacopy dentry, not the
>> topmost.  Am I missing something?
>
> Okay, it's more complicated.
>
> 1) there is an upper metacopy dentry:
>
>  - store origin (pointed to by ORIGIN or topmost lower dentry) in stack[0]

Ugh.  So if there's no ORIGIN, we don't want to store anything in
stack[0].   Wondering if we really need the data dentry in the
stack...  Ah, you add OVL_CONST_INO flag later in the series.  Good;
then we can just store data dentry in stack[0] if there's no origin.

Thanks,
Miklos
