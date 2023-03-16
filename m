Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73003C6FD1F
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Mar 2023 13:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCPNPK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 09:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjCPNPI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Mar 2023 09:15:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AD29018
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Mar 2023 06:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678972458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cij1DgoI5i6Ff0Me0upgsjOT5aDaEMgTlpSwTjH71C4=;
        b=VLpFvuXuGi2Y+kqUmbJlFkeDqjvJvhXEFx03t79g28RCl7PUpK98QOiL0SqC5d1kt5OiL1
        Bh0CknXUDdOJvMNAXGA6NlWivWbSMclR8pgKo8MhN9DnWZQ5YPRXeaxf8Xhs2EJLnLmsLV
        SmcYRUwITgilh1cCzUQEraXAwhman74=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-XO6vazZ6MRa7bm665tOaDg-1; Thu, 16 Mar 2023 09:14:15 -0400
X-MC-Unique: XO6vazZ6MRa7bm665tOaDg-1
Received: by mail-wm1-f69.google.com with SMTP id bd26-20020a05600c1f1a00b003ed23f09060so653277wmb.3
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Mar 2023 06:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678972454;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cij1DgoI5i6Ff0Me0upgsjOT5aDaEMgTlpSwTjH71C4=;
        b=C5bKuogAmvAh3+qMbleWinLCpYidixSYDGz1nXjvWiAXO+7+zYnjpCsn9sHyGbqnSK
         A5E2JlzAvW1aFtkW5K2ZaZ79oBO3r0OUG+Vhr4npBlW3xBOjdkn+9yDsEUBnkBVWgIYE
         hJvvivdtt9CxPTPzIcKAM3oXTA14HSk/a5Dht1cJ1rDcTuT9GIvs+cmzups+0uAWOFBG
         wG0Lq9z9C11eFmSowkA/KNy8qYZxUfimDLF5EjqAj54W+dMnlRdt6QAl4fcS31oQtzf9
         KOmE1xupLPXQTfsYYcmOxDIAmJWPPji0O7diWf9tfLVezS+ySLZ+dcGQ/wCuohz3e1rW
         k+XA==
X-Gm-Message-State: AO0yUKX91Oz9C6m/b8Mb9byxwSJJ/Ewi2ItXfocWVdXC+xr+rqbkrbCv
        LkQx72/zODX7BvSDmcJ4Wpn+DNmGJOGEydoyN04ZtSpdVb3RdfaUbg/+PBTITigm6bOgu2ZwANM
        JqJPgqKp7OHWu1rcvDY0YPfr7LA==
X-Received: by 2002:a7b:c394:0:b0:3ed:6693:1388 with SMTP id s20-20020a7bc394000000b003ed66931388mr1025910wmj.18.1678972453933;
        Thu, 16 Mar 2023 06:14:13 -0700 (PDT)
X-Google-Smtp-Source: AK7set8ZjMO0Y6+7kxovZnLoqzSDbEfVY0ZYumsiTW725vRLK5qi93k9OiMeyFdN6OokIatcXWlIng==
X-Received: by 2002:a7b:c394:0:b0:3ed:6693:1388 with SMTP id s20-20020a7bc394000000b003ed66931388mr1025892wmj.18.1678972453636;
        Thu, 16 Mar 2023 06:14:13 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id k18-20020a056000005200b002c71dd1109fsm7318197wrx.47.2023.03.16.06.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 06:14:13 -0700 (PDT)
Message-ID: <f312327e-c11e-60f4-1367-af4e480b2609@redhat.com>
Date:   Thu, 16 Mar 2023 14:14:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 04/15] overlayfs: Implement splice-read
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
References: <20230315163549.295454-1-dhowells@redhat.com>
 <20230315163549.295454-5-dhowells@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230315163549.295454-5-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 15.03.23 17:35, David Howells wrote:
> Implement splice-read for overlayfs by passing the request down a layer
> rather than going through generic_file_splice_read() which is going to be
> changed to assume that ->read_folio() is present on buffered files.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Christoph Hellwig <hch@lst.de>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Al Viro <viro@zeniv.linux.org.uk>
> cc: John Hubbard <jhubbard@nvidia.com>
> cc: David Hildenbrand <david@redhat.com>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: Miklos Szeredi <miklos@szeredi.hu>
> cc: linux-unionfs@vger.kernel.org
> cc: linux-block@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-mm@kvack.org
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

