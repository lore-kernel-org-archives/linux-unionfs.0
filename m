Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191024122923.24689-1-cgxu519@mykernel.net> <CAOQ4uxidZ=g29hGmKxinRA4Gp6CiWbOB9RqLWPPFXwtCB4DWog@mail.gmail.com>
 <16e007f78f9.12a9e815231850.7849365151361114799@mykernel.net>
 <CAOQ4uxgZDKnMGB3pbCJpyH_RxWzbEHLQMB2Mpc10PK=7=xYLOg@mail.gmail.com>
 <16e1244e1c9.ccaa038637864.8395134351025208019@mykernel.net>
 <CAOQ4uxjFvTTbKRW1BChnzfNSqg1yeyM3gjwjZ77i161D_XLFRg@mail.gmail.com> <16e12b4c2d4.107038d9f36138.3957762737837230842@mykernel.net>
In-Reply-To: <16e12b4c2d4.107038d9f36138.3957762737837230842@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 28 Oct 2019 16:34:11 +0200
Message-ID: <CAOQ4uxiw2EoeEW4bDCAYypaVZM9Ecqz1w=HHrM4KLaXfZNBNgw@mail.gmail.com>
Subject: Re: [PATCH v3] overlay/066: copy-up test for variant sparse files
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

>  >
>  > Not sure. I don't think we should target the test by what we know your
>  > patch does, but by maximizing test coverage in a cost effective way.
>  >
>  > Creating a 10M file with so many small holes doesn't add much to test
>  > coverage IMO. If you feel those are needed, you should use a C helper
>  > to create those files more efficiently.
>  >
>  > BTW I think what is missing from test coverage is small holes
>  > that are not aligned to 1M boundary.
>  >
>
> Agreed.
>
> So how about change test pattern to below, it will cover  most of the
> cases that we want. I haven't done test for the performance(test time)
> but I think it will be fast enough.
>
>
> One 4K empty file.
> One 4M empty file.
> One 10M file with random small holes (4K~512K)
> One 100M file with random big holes (1M~5M)
>
>

It sounds like a good addition, but maybe lets keep
the files with aligned holes iosize*10 in size?

Thanks,
Amir.
