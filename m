Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191221185149.17509-1-amir73il@gmail.com>
In-Reply-To: <20191221185149.17509-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 22 Dec 2019 23:19:21 +0200
Message-ID: <CAOQ4uxj2+ma4LEm14WdyXSkrHMrdWkwVzQd4r-WTqGdGJ8g2Rg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Nested overlay exportfs tests
Content-Type: text/plain; charset="UTF-8"
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Dec 21, 2019 at 8:51 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Eryu,
>

Eryu,

Actually, I needed to make a change to overlay/069, so please hold on
with these.

For test coverage, the interesting cases for nested overlay are:
- lower overlay is samefs
- lower overlay is non-samefs

That last case is especially interesting to exercise xino bit overflow,
because lower overlay uses the high ino bits.

This is not how I implemented overlay/069, so I made this change and
it caught another bug in upstream.

I have more nested tests coming soon, so I will post those along
with v2 of these tests.

Thanks and sorry for the noise,
Amir.
