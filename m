Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgecg_TuCkQrtY7Oj-vL34Mdj-FBsMgQByaKfNWZKFkkQ@mail.gmail.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com> <20180731093727.26855-10-yi.zhang@huawei.com>
 <CAOQ4uxgecg_TuCkQrtY7Oj-vL34Mdj-FBsMgQByaKfNWZKFkkQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 1 Aug 2018 14:35:27 +0300
Message-ID: <CAOQ4uxhsUekpXAKX5Nt8T9gFGK1fmkxWWYW4-aO02NM-g8FDvA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 9/9] ovl: check redirect_dir feature when detect
 redirect xattr on dir
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Aug 1, 2018 at 2:30 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> After we introduce the fsck.overlay program, we could check and fix
>> the inconsistency of feature set xattr, so it's a good opportunity
>> check the redirect dir feature when we detect redirect xattr on
>> directory in the underlying layer. If the feature is necessary
>> (OVL_FS_V2 for all layers and OVL_FS_UPPER_V2 for upper layer) but
>> the redirect dir feature is missing, the feature set is inconsistent
>> and fsck.overlay is required.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---

The concept of this patch is fine, but I would really like to review
it only after rebase with metacopy, because there are pretty big changes
for lookup+redirecet in metacopy patches.
And I would love to get Vivek's feedback on this patch.

Also, it might be enough just to check the feature bit inside
ovl_check_redirect() and warn - I am not sure that failing the lookup
is called for.

Thanks,
Amir.
