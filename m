From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 6/6] fsck.overlay: add impure xattr check
Date: Fri, 29 Dec 2017 09:03:28 +0200
Message-ID: <CAOQ4uxgPMCfVDPvST43Sd755p=Pohk=nCbMTOG=v_1khd96BvA@mail.gmail.com>
References: <20171228114023.43999-1-yi.zhang@huawei.com> <20171228114023.43999-7-yi.zhang@huawei.com>
 <CAOQ4uxjran64YjBvT4mWDsQgDZi+_NnommX2OTP-W1FdVJh75Q@mail.gmail.com> <5d420519-f19f-3bc9-eef1-74233c1650d1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <5d420519-f19f-3bc9-eef1-74233c1650d1@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Fri, Dec 29, 2017 at 4:21 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2017/12/28 21:18, Amir Goldstein Wrote:
>> On Thu, Dec 28, 2017 at 1:40 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>> An impure directory is a directory with "trusted.overlay.impure" xattr
>>> valued 'y', which indicate that this directory may contain copy-uped
>>> targets from lower layers. In oredr to prevent 'd_ino' change while
>>> copy-up (it create a new inode in upper layer) in getdents(2), impure
>>> xattr will be set in the parent directory, letting overlay filesystem
>>> check and get d_ino from lower origin target to ensure consistent d_ino.
>>>
>>> There are three situations of setting impure xattr:
>>> 1) Copyup lower target in a directory.
>>> 2) Link an origined target (already copy-uped, have origin xattr) into
>>>    a directory.
>>> 3) Rename an origined target (include merged subdirectories) into a
>>>    new directory.
>>>
>>> So, if a direcotry which contains several origined targets or redirect
>>> directories, the impure xattr should be set. If not, fix this xattr.
>>>
>>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>>> ---
[...]
>>>                 case FTS_DEFAULT:
>>>                         /* Check whiteouts */
>>> -                       err = __check_entry(sctx, sop->whiteout);
>>> -                       ret = (err) ? err : ret;
>>> +                       ret = scan_check_entry(sop->whiteout, sctx);
>>> +                       if (ret)
>>> +                               goto out;
>>> +
>>> +                       /* Check origin */
>>> +                       ret = scan_check_entry(sop->origin, sctx);
>>> +                       if (ret)
>>> +                               goto out;
>>
>> All the re-factoring of scan helpers and this additional origin check
>> do not seem relevant to this change's subject (impure dir check).
>>
> Current origin check function only count origin targets in a directory
> (this function can used for future check). Impure dir check use this
> counts to distinguish this directory is impure or not, so this origin
> check is necessary in this patch.
>

I see. Anyway, the cleaner the patch is, the easier it is to review it.
A re-factoring patch that does not change behavior and declares this
in commit message is easy to verify in review and a logic change
patch that declares the logical change in commit message is easy to
review. Mixing them both in a single patch without being able to declare
that this is only a logical change not that this is only re-factoring makes
reviewing harder.

This is generally speaking. This patch was easy enough to review
anyway, but other reviewers may not feel the same way.

Cheers,
Amir.
