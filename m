From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 04/17] ovl: decode connected upper dir file handles
Date: Mon, 15 Jan 2018 12:41:25 +0100
Message-ID: <CAJfpegsZTQ6Gn1Y6Ddjo47H7MrJsT5xWaDCZP4MswGt2vBt4jg@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-5-git-send-email-amir73il@gmail.com> <CAOQ4uxhpNCUzcuFSvntAN_JDB=L5NDqZP4m9TxytyO-P6t3F0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhpNCUzcuFSvntAN_JDB=L5NDqZP4m9TxytyO-P6t3F0Q@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jan 5, 2018 at 1:33 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Jan 4, 2018 at 7:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Until this change, we decoded upper file handles by instantiating an
>> overlay dentry from the real upper dentry. This is sufficient to handle
>> pure upper files, but insufficient to handle merge/impure dirs.
>>
>> To that end, if decoded real upper dir is connected and hashed, we
>> lookup an overlay dentry with the same path as the real upper dir.
>> If decoded real upper is non-dir, we instantiate a disconnected overlay
>> dentry as before this change.
>>
>> Because ovl_fh_to_dentry() returns connected overlay dir dentries,
>> exportfs never need to call get_parent() and get_name() to reconnect an
>> upper overlay dir. Because connectable non-dir file handles are not
>> supported, exportfs will not be able to use fh_to_parent() and get_name()
>> methods to reconnect a disconnected non-dir to its parent. Therefore, the
>> methods get_parent() and get_name() are implemented just to print out a
>> sanity warning and the method fh_to_parent() is implemented to warn the
>> user that using the 'subtree_check' exportfs option is not supported.
>>
>
> Reviewers who will get this far, should have their eyebrows slightly raised
> after reading this commit message and should be asking themselves:
>
> "Why not return a disconnected overlay dentry like any other fs and implement
> ovl_get_parent()/ovl_get_name() by looking at parent/name of upper dir?"
>
> I have had this debate with myself for a while and experimented a bit with
> both approaches and in the end, I liked the "return connected dentry" result
> better. I did not want to write this entire story in commit message, because
> in the end, there is nothing incorrect about the choice of either implementation
> there are only pros and cons to each choice.
>
> At the moment, the only argument I can think of to counter the chosen approach
> is that it adds ~100 lines on code in ovl_lookup_real() and
> ovl_lookup_real_one()
> helpers that could have been avoided by using the common reconnect_path()
> code in fs/exportfs/expfs.c.

And also not having to deal with rename races would be good.  And the
way to do it is the same way as ovl_get_redirect(), except now we are
walking the upper layer instead of the overlay layer.

Not sure which approach is better.

Thanks,
Miklos
