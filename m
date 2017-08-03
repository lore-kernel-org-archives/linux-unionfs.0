From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: xattr hash error in 4.13-rc with overlayfs over ext4
Date: Thu, 3 Aug 2017 13:10:55 +0200
Message-ID: <CAJfpegvK9AhRVDhABWS=MkBSEfd9oGmOxTPVYSfPWGbTAbEhVw@mail.gmail.com>
References: <CAJfpegvQhuMnt=2TtfYSiMV=DTLLLbOfrvcR2xQrmvyPU9wSNg@mail.gmail.com>
 <CAAeU0aM-1UFJJvX3zF1wUjBeG8BGC+S0wn7PhiDZevTscvmkXg@mail.gmail.com>
 <CAJfpegvL2iR1PZ+3S=VGtbUiVPQ-EnW28KwE4wCzMJwWptNYKg@mail.gmail.com>
 <CAJfpegtLsnDFwMFMMxUf2yUcr2AG57PgUZSAR7M8gzbOEp16Mg@mail.gmail.com>
 <CAAeU0aOC7i6dTEBKRAP3N_HUKR0CQOW4j_MhftkfC9FSXHdCAw@mail.gmail.com>
 <CAJfpegvy274dZ0ZzY+qpaLwREi0QU9jNt=vE0pBpQ8W2wWCx1w@mail.gmail.com> <CAOQ4uxjtLVuuYyDZ7csJeb_xbMiWHDHs21tgQoB7bbLWC6DUew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjtLVuuYyDZ7csJeb_xbMiWHDHs21tgQoB7bbLWC6DUew@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Tahsin Erdogan <tahsin@google.com>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Aug 1, 2017 at 12:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Jul 31, 2017 at 7:08 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Jul 27, 2017 at 10:54 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>>> Still no luck reproducing the error. I am using the test script below
>>> at v4.13-rc2. Do you mind checking my script to see what I am missing?
>>
>> Don't know.   I can reliably reproduce it under UML, but not with a
>> VM.  What the hell is going on?
>>
>
> Is it the same ext4 image for UML and VM? same image size? same mkfs version?

Exact same starting image.  Same userspace.  Same EXT4 kernel config options.

Thanks,
Miklos
