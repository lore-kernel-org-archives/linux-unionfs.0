From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstests PATCH v6 0/8] overlay: add fsck.overlay basic tests
Date: Wed, 24 Jan 2018 11:41:39 +0200
Message-ID: <CAOQ4uxhU7k9SGmwA_vk9hiaYbW11oC1sSHiLtAxJgUBMRsJy8Q@mail.gmail.com>
References: <20180124073344.31970-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180124073344.31970-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jan 24, 2018 at 9:33 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi All:
>
> Here is the sixth version of test cases for the fsck.overlay[1].

You know, I wanted to say this earlier.
This series is a mix of 2 independent series and I don't know if
it is best for you to post them together.

The 3 tests added to overlay/fsck group only require the minimal
helper _overlay_fsck_dirs.

The rest of the patches really do something very different than testing
overlay.fsck itself.

If you hadn't combined the 2 series together, the overlay/fsck series
would have completed review 2-3 revisions ago.

I'll leave it to you to decide if to post the next revision as one series
or two, but I think it would be better if you at least re-order the
patches so that the already reviewed overlay/fsck patches
with the simple _overlay_fsck_dirs helper are before the rest of
the patches.

Thanks,
Amir.
