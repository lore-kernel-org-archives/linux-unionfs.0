Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191024122923.24689-1-cgxu519@mykernel.net>
In-Reply-To: <20191024122923.24689-1-cgxu519@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 25 Oct 2019 00:02:07 +0300
Message-ID: <CAOQ4uxidZ=g29hGmKxinRA4Gp6CiWbOB9RqLWPPFXwtCB4DWog@mail.gmail.com>
Subject: Re: [PATCH v3] overlay/066: copy-up test for variant sparse files
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 24, 2019 at 3:29 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> This is intensive copy-up test for sparse files,
> these cases will be mainly used for regression test
> of copy-up improvement for sparse files.
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>
> ---
> v1->v2:
> - Call _get_block_size to get fs block size.
> - Add comment for test space requirement.
> - Print meaningful error message when copy-up fail.
> - Adjust random hole range to 1M~5M.
> - Fix typo.
>
> v2->v3:
> - Fix space requiremnt for test.
> - Add more descriptions for test files and hole patterns.
> - Define well named variables to replace unexplained numbers.
> - Fix random hole algorithm to what Amir suggested.
> - Adjust iosize to start from 1K.
> - Remove from quick test group.

Why? you said it takes 7s without the kernel patch.
The test overlay/001 is in quick group and it copies up 2*4GB
sparse files.

Tests that are not in quick group are far less likely to be run
regularly by developers.

Otherwise looks good.

Thanks,
Amir.
