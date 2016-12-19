From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] generic/396: test correct d_type value
Date: Mon, 19 Dec 2016 18:26:05 +0200
Message-ID: <CAOQ4uxiGJ-aq0aaqFYHfMSuSynGT3moym=HhSaWsOW+bZgMZqg@mail.gmail.com>
References: <1482164108-19389-1-git-send-email-amir73il@gmail.com> <20161219162247.GA12627@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34694 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755407AbcLSQ0G (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Dec 2016 11:26:06 -0500
In-Reply-To: <20161219162247.GA12627@infradead.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Mon, Dec 19, 2016 at 6:22 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Dec 19, 2016 at 06:15:08PM +0200, Amir Goldstein wrote:
>> Verify correct d_type values of dir enrties.
>>
>> This test would fail for file systems with no d_type support,
>> but I have no idea how to test d_type support in a generic way,
>> without confusing a bug of d_type = DT_UNKNOWN with no support.
>
> XFS v4 without the rare ftype feature is such a file system.
>
> We'll need to detect it, and I think a large enough directory where
> all entries but . and .. are DT_UNKNOWN should be a clear indicator.
>
> If that's a bug it's clearly not distinguishable from a non-buggy fs :)

For xfs and ext* I know how to test if the feature is enabled and I probably
should do that. The question is what to do with the rest of the fs.
I can do the heuristic test you suggested...
