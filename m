From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v2 0/4] overlay: add fsck.overlay basic tests
Date: Wed, 31 Jan 2018 18:25:55 +0800
Message-ID: <20180131102555.GH18267@eguan.usersys.redhat.com>
References: <20180131102604.40701-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180131102604.40701-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

Hi Yi,

On Wed, Jan 31, 2018 at 06:26:00PM +0800, zhangyi (F) wrote:
> Hi Eryu:
> 
> This is the test cases for the fsck.overlay[1] to test orphan whiteout,
> invalid/duplicate reiderct dirs, and the missing impure xattr. These
> works only when fsck.overlay exists. (These patchset split form origin
> patchset[2])
> 
> This revision have already handled all comments form Amir, please review.

Thanks for all the revisions and reviews from Amir! I'm sorry that I'm a
bit absent from previous reviews, I kind of relying on Amir's reviews..

I'll try to go through all the fsck.overlay backgrounds and tests as
quickly as I can.

Thanks,
Eryu
