MIME-Version: 1.0
In-Reply-To: <CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
	<20180507174102.24086-11-vgoyal@redhat.com>
	<CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com>
Date: Thu, 10 May 2018 11:36:16 +0200
Message-ID: <CAJfpegtizFNe3tm7reYMYGBsmD-dzZTHNsSGrb5BZ_gaeu2Sfw@mail.gmail.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 10, 2018 at 11:19 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, May 7, 2018 at 7:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>
>> +               if (d.metacopy)
>> +                       metacopy = true;
>> +               /*
>> +                * Do not store intermediate metacopy dentries in chain,
>> +                * except top most lower metacopy dentry
>
> I don't get it.  We need the bottom most metacopy dentry, not the
> topmost.  Am I missing something?

Okay, it's more complicated.

1) there is an upper metacopy dentry:

 - store origin (pointed to by ORIGIN or topmost lower dentry) in stack[0]
 - store data dentry (lowest in metacopy chain) in stack[1], unless
it's the same as origin

2) there is no upper dentry, but a lower metacopy dentry

 - store metacopy dentry in stack[0]
 - store data dentry in stack[1]

Does that make more sense?

> We also need to check file type here, only regular file makes sense as
> metacopy, so if it's something else, then get out with EIO.

I meant file type of *data* inode.  Type of metacopy inode is already
checked by ovl_check_metacopy_xattr().

Thanks,
Miklos
