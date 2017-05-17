From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: potential Oops in ovl_rename()
Date: Wed, 17 May 2017 23:02:32 +0300
Message-ID: <CAOQ4uxjAUrxGQJTX1ve0VXAnAZwcgytfdxPkoWHbwLvKbJeeKQ@mail.gmail.com>
References: <20170517192903.eccqpknwlpd7axqb@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36662 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbdEQUCd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 May 2017 16:02:33 -0400
In-Reply-To: <20170517192903.eccqpknwlpd7axqb@mwanda>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>, kernel-janitors@vger.kernel.org

On Wed, May 17, 2017 at 10:29 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> We can't do a "goto out_dput;" because "newdentry" isn't initialized
> yet.
>

Right. copy&paste typo.
Already posted a fix yesterday ("ovl: fix wrong error handling of
ovl_set_impure()")

Thanks!
