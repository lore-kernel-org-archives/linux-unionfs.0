MIME-Version: 1.0
In-Reply-To: <CAJfpeguVb-u2Tzrz2f1L3bgE8QS+cwhCpBsfW3=+J8s-jZerBw@mail.gmail.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
	<20180507174102.24086-11-vgoyal@redhat.com>
	<CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com>
	<20180510193913.GA11152@redhat.com>
	<CAJfpeguVb-u2Tzrz2f1L3bgE8QS+cwhCpBsfW3=+J8s-jZerBw@mail.gmail.com>
Date: Fri, 11 May 2018 09:29:50 +0200
Message-ID: <CAJfpegtOADQ_gpLxrMRWoXqf8Q3Fe9FyF=Q8pQit0F656=c3ug@mail.gmail.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 10, 2018 at 10:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

>  - if upper has REDIRECT, then use that to determine origin (just like
> directories)
>  - else if upper has METACOPY, then go down one level to determine
> origin (just like directories)
>  - else if upper has ORIGIN, then use that as origin (not applicable
> to directories (*))
>  - else no origin (just like directories)

Desirable way to find origin summarized in a table:

lookup by   dir            reg       special
--------------------------------------------
redirect    REDIRECT       REDIRECT  n/a
next layer  default        METACOPY  n/a
origin fh   OPAQUE+ORIGIN  ORIGIN    ORIGIN
stop        OPAQUE         default   default

Thanks,
Miklos
