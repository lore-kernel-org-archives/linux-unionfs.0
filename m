Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1527965539-30607-1-git-send-email-amir73il@gmail.com>
References: <1527965539-30607-1-git-send-email-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 5 Jun 2018 15:09:59 +0300
Message-ID: <CAOQ4uxiw12OvPxtyzZgyoKNKW69J0=VTRTM3CMa4mxBQLj5c3g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] overlay/016: split into two tests
Content-Type: text/plain; charset="UTF-8"
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Jun 2, 2018 at 9:52 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> overlay/016 tests two cases of ro/rw fd data inconsistecies -
> one using pread and one using mmap read (i.e. mread).
>
> The first case will pass as soon as stacked overlay operations
> patch set is merged. The second case requires enabling a new opt-in
> feature "copy_up_shared" in order to pass.
>
> Instead of changing the entire test from fail to notrun, split
> the two cases into two tests and require the new feature only
> for the new test.
>
> This way, the new test will change from notrun to pass with
> stacked overlay operations and the old test will change from
> fail to pass.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Eryu,

Please hold back on this patch - there seems to be a push back
on the "copy_up_shared" feature.
It may end up making sense to do the split anyway because
case #1 may be resolved in this merge cycle and case #2 only
later on, but let's wait to see what gets merged first and then decide.

No problem with merging the cleanup patch
"overlay: nicer report when features are not supported"

Thanks,
Amir.
