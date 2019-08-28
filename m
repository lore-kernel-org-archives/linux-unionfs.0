From: Mark Salyzyn via Linux-f2fs-devel
 <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [PATCH v8] Add flags option to get xattr method
 paired to __vfs_getxattr
Date: Wed, 28 Aug 2019 07:40:15 -0700
Message-ID: <5dd09a38-fffb-36f2-505b-be2ddf6bb750@android.com>
References: <20190827150544.151031-1-salyzyn@android.com>
 <20190828142423.GA1955@infradead.org>
Reply-To: Mark Salyzyn <salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190828142423.GA1955@infradead.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@infradead.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Hugh Dickins <hughd@google.com>, Mike Marshall <hubcap@omnibond.com>, James Morris <jmorris@namei.org>, devel@lists.orangefs.org, Eric Van Hensbergen <ericvh@gmail.com>, Joel Becker <jlbec@evilplan.org>, Anna Schumaker <anna.schumaker@netapp.com>, Trond Myklebust <trond.myklebust@hammerspace.com>, Mathieu Malaterre <malat@debian.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, Casey Schaufler <casey@schaufler-ca.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Kleikamp <shaggy@kernel.org>, linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, linux-cifs@vger.kernel.org, Paul Moore <paul@paul-moore.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, kernel-team@android.com, selinux@vger.kernel.o
List-Id: linux-unionfs@vger.kernel.org

T24gOC8yOC8xOSA3OjI0IEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBPbiBUdWUsIEF1
ZyAyNywgMjAxOSBhdCAwODowNToxNUFNIC0wNzAwLCBNYXJrIFNhbHl6eW4gd3JvdGU6Cj4+IFJl
cGxhY2UgYXJndW1lbnRzIGZvciBnZXQgYW5kIHNldCB4YXR0ciBtZXRob2RzLCBhbmQgX192ZnNf
Z2V0eGF0dHIKPj4gYW5kIF9fdmZzX3NldGF4dHIgZnVuY3Rpb25zIHdpdGggYSByZWZlcmVuY2Ug
dG8gdGhlIGZvbGxvd2luZyBub3cKPj4gY29tbW9uIGFyZ3VtZW50IHN0cnVjdHVyZToKPiBZaWtl
cy4gIFRoYXQgbG9va3MgbGlrZSBhIG1lc3MuICBXaHkgY2FuJ3Qgd2UgcGFzcyBhIGtlcm5lbC1v
bmx5Cj4gZmxhZyBpbiB0aGUgZXhpc3RpbmcgZmxhZ3MgZmllbGQgZm9yIOKCiz5zZXQgYW5kIGFk
ZCBhIGZsYWdzIGZpZWxkCj4gdG8gLT5nZXQ/ICBQYXNzaW5nIG1ldGhvZHMgYnkgc3RydWN0dXJl
IGFsd2F5cyB0ZW5kcyB0byBiZSBhIG1lc3MuCgpUaGlzIHdhcyBhIHJlc3BvbnNlIHRvIEdyZWdL
SEAgY3JpdGljaXNtLCBhbiBlYXJsaWVyIHBhdGNoIHNldCBqdXN0IAphZGRlZCBhIGZsYWcgYXMg
eW91IHN0YXRlZCB0byBnZXQgbWV0aG9kLCB1bnRpbCBjb21wbGFpbnRzIG9mIGFuIApleGNlc3Np
dmVseSBsb25nIGFyZ3VtZW50IGxpc3QgYW5kIGZyYWdpbGl0eSB0byBhZGQgb3IgY2hhbmdlIG1v
cmUgCmFyZ3VtZW50cy4KClNvIG1hbnkgd2F5cyBoYXZlIGJlZW4gdHJpZWQgdG8gc2tpbiB0aGlz
IGNhdCAuLi4gdGhlIHJpc2sgd2FzIHRha2VuIHRvIApwbGVhc2Ugc29tZSwgYW5kIHdlIG5vdyBo
YXZlIGh1bmRyZWRzIG9mIHN0YWtlaG9sZGVycywgd2hlbiB0aGUgZmlyc3QgCnBhdGNoIHNldCB3
YXMgbGVzcyB0aGFuIGEgZG96ZW4uIEEgcmVjaXBlIGZvciBmYWlsdXJlPwoKLS0gTWFyawoKCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1mMmZz
LWRldmVsIG1haWxpbmcgbGlzdApMaW51eC1mMmZzLWRldmVsQGxpc3RzLnNvdXJjZWZvcmdlLm5l
dApodHRwczovL2xpc3RzLnNvdXJjZWZvcmdlLm5ldC9saXN0cy9saXN0aW5mby9saW51eC1mMmZz
LWRldmVsCg==
