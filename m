From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: xattr hash error in 4.13-rc with overlayfs over ext4
Date: Sun, 6 Aug 2017 13:05:41 -0700
Message-ID: <CAAeU0aMZ12Ff5dghWwB=EWtNFSZz=iWaMBsP75pqYdypNpg8zA@mail.gmail.com>
References: <CAJfpegvQhuMnt=2TtfYSiMV=DTLLLbOfrvcR2xQrmvyPU9wSNg@mail.gmail.com>
 <CAAeU0aM-1UFJJvX3zF1wUjBeG8BGC+S0wn7PhiDZevTscvmkXg@mail.gmail.com>
 <CAJfpegvL2iR1PZ+3S=VGtbUiVPQ-EnW28KwE4wCzMJwWptNYKg@mail.gmail.com>
 <CAJfpegtLsnDFwMFMMxUf2yUcr2AG57PgUZSAR7M8gzbOEp16Mg@mail.gmail.com>
 <CAAeU0aOC7i6dTEBKRAP3N_HUKR0CQOW4j_MhftkfC9FSXHdCAw@mail.gmail.com>
 <CAJfpegvy274dZ0ZzY+qpaLwREi0QU9jNt=vE0pBpQ8W2wWCx1w@mail.gmail.com>
 <CAOQ4uxjtLVuuYyDZ7csJeb_xbMiWHDHs21tgQoB7bbLWC6DUew@mail.gmail.com>
 <CAJfpegvK9AhRVDhABWS=MkBSEfd9oGmOxTPVYSfPWGbTAbEhVw@mail.gmail.com> <ce8741f2-bc8c-430d-2192-c2776afa0379@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <ce8741f2-bc8c-430d-2192-c2776afa0379@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "zhangyi (F)" <yizhang089@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Aug 6, 2017 at 5:47 AM, zhangyi (F) <yizhang089@gmail.com> wrote:
> I think the root cause of this problem is the hash value not updated
> when we overwrite the same xattr, please see ext4_xattr_set_entry():

Yes, you are right. Thanks a lot for finding the root cause.

I just sent out a fix: ("[PATCH] ext4: add missing xattr hash update")

http://patchwork.ozlabs.org/patch/798445/
