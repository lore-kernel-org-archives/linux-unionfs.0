Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1523623156-6035-1-git-send-email-cgxu519@gmx.com>
References: <1523623156-6035-1-git-send-email-cgxu519@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 13 Apr 2018 15:56:13 +0300
Message-ID: <CAOQ4uxhRuU5okDMCLxE4kxB0zTQfY_K9_DCvOnAVXm676yE_Jg@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] option validation in remount
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Apr 13, 2018 at 3:39 PM, Chengguang Xu <cgxu519@gmx.com> wrote:
> Some overlayfs mount options cannot be changed via remount,
> but current remount does not return error even if we specify
> different value to unchangeable options.
>
> This patch series adjust option parsing to support remount
> and return proper error message and code when recogonizing
> unchangeable options in remount.
>

Surely, you have motivation beyond what is listed here.
Would be nice to list short and long term goals for changing
remount options.

The series looks ok to me.
There is a question whether erroring on remount with changed
options is considered a regression to some applications.
I don't know how to answer that.
Does your use case *require* that remount will fail?
Would it be ok to ignore unchangeable options like today,
but warn about it?

After Miklos approves the expected behavior,
please write xfstests to verify expected behavior.

Thanks,
Amir.
