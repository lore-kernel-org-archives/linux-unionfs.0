From: "zhangyi (F)" <yizhang089@gmail.com>
Subject: Re: xattr hash error in 4.13-rc with overlayfs over ext4
Date: Sun, 6 Aug 2017 20:47:20 +0800
Message-ID: <ce8741f2-bc8c-430d-2192-c2776afa0379@gmail.com>
References: <CAJfpegvQhuMnt=2TtfYSiMV=DTLLLbOfrvcR2xQrmvyPU9wSNg@mail.gmail.com>
 <CAAeU0aM-1UFJJvX3zF1wUjBeG8BGC+S0wn7PhiDZevTscvmkXg@mail.gmail.com>
 <CAJfpegvL2iR1PZ+3S=VGtbUiVPQ-EnW28KwE4wCzMJwWptNYKg@mail.gmail.com>
 <CAJfpegtLsnDFwMFMMxUf2yUcr2AG57PgUZSAR7M8gzbOEp16Mg@mail.gmail.com>
 <CAAeU0aOC7i6dTEBKRAP3N_HUKR0CQOW4j_MhftkfC9FSXHdCAw@mail.gmail.com>
 <CAJfpegvy274dZ0ZzY+qpaLwREi0QU9jNt=vE0pBpQ8W2wWCx1w@mail.gmail.com>
 <CAOQ4uxjtLVuuYyDZ7csJeb_xbMiWHDHs21tgQoB7bbLWC6DUew@mail.gmail.com>
 <CAJfpegvK9AhRVDhABWS=MkBSEfd9oGmOxTPVYSfPWGbTAbEhVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <CAJfpegvK9AhRVDhABWS=MkBSEfd9oGmOxTPVYSfPWGbTAbEhVw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: Tahsin Erdogan <tahsin@google.com>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On 2017/8/3 19:10, Miklos Szeredi Wrote:
> On Tue, Aug 1, 2017 at 12:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Mon, Jul 31, 2017 at 7:08 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Thu, Jul 27, 2017 at 10:54 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>>>> Still no luck reproducing the error. I am using the test script below
>>>> at v4.13-rc2. Do you mind checking my script to see what I am missing?
>>>
>>> Don't know.   I can reliably reproduce it under UML, but not with a
>>> VM.  What the hell is going on?
>>>
>>
>> Is it the same ext4 image for UML and VM? same image size? same mkfs version?
> 
> Exact same starting image.  Same userspace.  Same EXT4 kernel config options.
> 
> Thanks,
> Miklos
> 

Hi:
I think the root cause of this problem is the hash value not updated
when we overwrite the same xattr, please see ext4_xattr_set_entry():

static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
				struct ext4_xattr_search *s,
				handle_t *handle, struct inode *inode,
				bool is_block)
{
...
	if (new_size && new_size == old_size) {
		size_t offs = le16_to_cpu(here->e_value_offs);
		void *val = s->base + offs;

		here->e_value_size = cpu_to_le32(i->value_len);
		if (i->value == EXT4_ZERO_XATTR_VALUE) {
			memset(val, 0, new_size);
		} else {
			memcpy(val, i->value, i->value_len);
			/* Clear padding bytes. */
			memset(val + i->value_len, 0, new_size - i->value_len);
		}

		/* Forget updating *here->e_hash* and *s->base->h_hash* here. */

		return 0;
	}
...
	/* Call ext4_xattr_hash_entry && ext4_xattr_rehash first set */
...
}

Thanks,
ZhangYi
